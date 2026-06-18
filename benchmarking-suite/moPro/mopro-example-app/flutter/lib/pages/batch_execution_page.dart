import 'package:flutter/material.dart';
import 'dart:async';
import '../models/benchmark_item.dart';
import '../services/benchmark_service.dart';
import '../utils/circuit_registry.dart';
import '../utils/circuit_utils.dart';
import '../utils/benchmark_references.dart';
import '../services/api_service.dart';
import '../services/device_stats_service.dart';
import 'package:Deimos/theme/app_theme.dart';
import 'package:Deimos/widgets/instrument_widgets.dart';

class BatchExecutionPage extends StatefulWidget {
  final List<InputData> allInputs;

  const BatchExecutionPage({super.key, required this.allInputs});

  @override
  State<BatchExecutionPage> createState() => _BatchExecutionPageState();
}

class _BatchExecutionPageState extends State<BatchExecutionPage> {
  final BenchmarkService _benchmarkService = BenchmarkService();
  late List<BenchmarkResult> _results;
  bool _isExecuting = false;
  int _completedCount = 0;
  int _failedCount = 0;
  bool _isPushing = false;
  Stopwatch _totalStopwatch = Stopwatch();
  ScrollController _scrollController = ScrollController();

  // Progressive upload: flush completed results in chunks during the run so a
  // mid-batch crash doesn't lose everything captured so far.
  static const int _uploadChunkSize = 10;
  final List<Map<String, dynamic>> _pendingUpload = [];
  Map<String, dynamic>? _deviceInfo; // collected once per run
  int _uploadedCount = 0;

  @override
  void initState() {
    super.initState();
    _results = CircuitRegistry.getFullBenchmarkSuite();
    _startBatch();
  }

  Future<void> _startBatch() async {
    setState(() {
      _isExecuting = true;
      _completedCount = 0;
      _failedCount = 0;
      _uploadedCount = 0;
    });
    _pendingUpload.clear();
    _deviceInfo ??= await DeviceStatsService.collectDeviceInfo({});
    _totalStopwatch.start();

    for (int i = 0; i < _results.length; i++) {
      if (!mounted) break;

      // Let memory from the previous circuit's proof release before the next baseline.
      if (i > 0) await Future.delayed(const Duration(milliseconds: 300));

      final item = _results[i];
      final inputData = _findInputForitem(item);

      setState(() {
        _results[i] = item.copyWith(status: BenchmarkStatus.proving);
      });
      _scrollToItem(i);

      final result = await _benchmarkService.runBenchmark(_results[i], inputData);

      if (!mounted) break;

      setState(() {
        _results[i] = result;
        if (result.status == BenchmarkStatus.completed) {
          _completedCount++;
        } else {
          _failedCount++;
        }
      });

      // Buffer completed results and flush in chunks for crash resilience.
      if (result.status == BenchmarkStatus.completed) {
        _pendingUpload.add(_buildPayload(result, _deviceInfo!));
        if (_pendingUpload.length >= _uploadChunkSize) {
          await _flushPending();
        }
      }
    }

    await _flushPending(); // flush the remainder

    _totalStopwatch.stop();
    if (mounted) {
      setState(() {
        _isExecuting = false;
      });
    }
  }

  /// Builds the upload payload for one completed result (memory + cpu nested
  /// under deviceInfo so the backend persists them).
  Map<String, dynamic> _buildPayload(BenchmarkResult result, Map<String, dynamic> deviceInfo) {
    final inputData = _findInputForitem(result);
    return {
      'circuit': result.algorithm,
      'framework': 'MoPro',
      'language': result.framework,
      'provingTimeMiliSeconds': result.provingTime?.inMilliseconds ?? 0,
      'verificationTimeMiliSeconds': result.verificationTime?.inMilliseconds ?? 0,
      'deviceInfo': {
        ...deviceInfo,
        'memory': result.memoryInfo,
        'cpu': result.cpuInfo,
      },
      'proofSize': result.proofSize,
      'inputSize': CircuitUtils.computeInputSize(result.inputName, inputData.values.length),
      'customInputs': {result.inputName: '[${inputData.values.join(', ')}]'},
      'proofBackend': (result.framework == 'arkworks' || result.framework == 'rapidsnark') ? result.framework : 'N/A',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Uploads the pending buffer; re-queues on failure so a later flush retries
  /// (server dedups, so retries never create duplicate rows).
  Future<void> _flushPending() async {
    if (_pendingUpload.isEmpty) return;
    final chunk = List<Map<String, dynamic>>.from(_pendingUpload);
    _pendingUpload.clear();
    final summary = await ApiService.sendBenchmarkBatch(chunk);
    if (summary != null) {
      final inserted = (summary['inserted'] ?? 0) as int;
      if (mounted) {
        setState(() => _uploadedCount += inserted);
      } else {
        _uploadedCount += inserted;
      }
    } else {
      _pendingUpload.insertAll(0, chunk);
    }
  }

  InputData _findInputForitem(BenchmarkResult item) {
    try {
      return widget.allInputs.firstWhere(
        (input) => input.name == item.inputName,
        orElse: () => widget.allInputs.first,
      );
    } catch (_) {
      return InputData(name: 'Default', description: 'Fallback', values: ['17']);
    }
  }

  void _scrollToItem(int index) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        index * 120.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pushToDatabase() async {
    setState(() {
      _isPushing = true;
    });

    final deviceInfo = _deviceInfo ??= await DeviceStatsService.collectDeviceInfo({});

    // Catch-all: re-send every completed result in one request. Progressive
    // upload already sent most during the run; duplicates dedupe server-side.
    final List<Map<String, dynamic>> batch = [
      for (final result in _results)
        if (result.status == BenchmarkStatus.completed) _buildPayload(result, deviceInfo),
    ];

    Map<String, dynamic>? summary;
    if (batch.isNotEmpty) {
      summary = await ApiService.sendBenchmarkBatch(batch);
    }

    setState(() {
      _isPushing = false;
    });

    if (mounted) {
      final String message;
      final Color color;
      if (batch.isEmpty) {
        message = 'No completed results to push.';
        color = AppTheme.warning;
      } else if (summary == null) {
        message = 'Database push failed.';
        color = AppTheme.warning;
      } else {
        message = 'Database Push: ${summary['inserted'] ?? 0} saved, ${summary['skipped'] ?? 0} duplicate(s).';
        color = AppTheme.success;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SIMono(message, color: AppTheme.background),
          backgroundColor: color,
        ),
      );
    }
  }

  // Returns the index of the fastest completed result, or -1 if none.
  int _winnerIndex() {
    int best = -1;
    int bestMs = -1;
    for (int i = 0; i < _results.length; i++) {
      final r = _results[i];
      if (r.status != BenchmarkStatus.completed) continue;
      final ms = (r.provingTime?.inMilliseconds ?? 0) + (r.verificationTime?.inMilliseconds ?? 0);
      if (bestMs == -1 || ms < bestMs) {
        bestMs = ms;
        best = i;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    int maxTime = 1;
    for (var r in _results) {
      if (r.status == BenchmarkStatus.completed) {
        final t = (r.provingTime?.inMilliseconds ?? 0) + (r.verificationTime?.inMilliseconds ?? 0);
        if (t > maxTime) maxTime = t;
      }
    }

    final winnerIdx = !_isExecuting ? _winnerIndex() : -1;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SIBar(
              title: '// CROSS-FRAMEWORK',
              onBack: () => Navigator.pop(context),
              right: !_isExecuting
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _results = CircuitRegistry.getFullBenchmarkSuite();
                        });
                        _startBatch();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.border)),
                        child: const SIMono('RESTART', fontSize: 10, letterSpacing: 1.5),
                      ),
                    )
                  : null,
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SIMono('${_results.length} FRAMEWORKS BENCHED', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                  const SizedBox(height: 6),
                  SIMono(
                    _isExecuting ? 'Benchmarking in progress...' : 'Batch execution complete.',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final r = _results[index];
                  final fwName = CircuitRegistry.getFrameworkDisplayName(r.framework);
                  final totalMs = (r.provingTime?.inMilliseconds ?? 0) + (r.verificationTime?.inMilliseconds ?? 0);

                  final isWinner = !_isExecuting && index == winnerIdx;
                  final isActive = r.status == BenchmarkStatus.proving || r.status == BenchmarkStatus.verifying;
                  final isFailed = r.status == BenchmarkStatus.failed;
                  final isDone = r.status == BenchmarkStatus.completed;

                  Color borderColor = isWinner
                      ? AppTheme.accent
                      : (isActive ? AppTheme.accent : AppTheme.border);
                  if (isFailed) borderColor = AppTheme.danger;

                  final widthPct = (isDone && maxTime > 0)
                      ? (totalMs / maxTime).clamp(0.0, 1.0)
                      : 0.0;

                  // Memory consumed in MB from memoryInfo (process-level).
                  final memConsumedMb = isDone && r.memoryInfo != null
                      ? ((r.memoryInfo!['memoryConsumedByProof'] as int? ?? 0).abs()) /
                          (1024 * 1024)
                      : null;

                  // Proof size in KB
                  final proofKb = isDone && (r.proofSize ?? 0) > 0
                      ? r.proofSize! / 1024.0
                      : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SIMono(
                                    '#${(index + 1).toString().padLeft(2, '0')}',
                                    fontSize: 11,
                                    letterSpacing: 1,
                                    color: isWinner ? AppTheme.accent : (isActive ? AppTheme.accent : AppTheme.textDim),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: SIMono(
                                      '$fwName · ${r.algorithm}',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isWinner) ...[
                                    const SizedBox(width: 8),
                                    const SITag(text: 'FASTEST', invert: true),
                                  ],
                                  if (isActive) ...[
                                    const SizedBox(width: 8),
                                    const SITag(text: 'RUNNING'),
                                  ],
                                  if (isFailed) ...[
                                    const SizedBox(width: 8),
                                    const SITag(text: 'FAILED', accent: true),
                                  ],
                                ],
                              ),
                            ),
                            if (isDone)
                              SIMono(
                                BenchmarkReferences.formatMs(totalMs),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            border: Border.all(color: AppTheme.border),
                          ),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: isActive ? 1.0 : widthPct,
                            child: Container(
                              color: isFailed
                                  ? AppTheme.danger
                                  : (isWinner ? AppTheme.accent : (isActive ? AppTheme.accent : AppTheme.text)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SIMono('GEN ${r.provingTime?.inMilliseconds ?? 0}ms', fontSize: 10, color: AppTheme.textDim),
                            const SizedBox(width: 14),
                            SIMono('VER ${r.verificationTime?.inMilliseconds ?? 0}ms', fontSize: 10, color: AppTheme.textDim),
                            if (memConsumedMb != null) ...[
                              const SizedBox(width: 14),
                              SIMono('MEM ${memConsumedMb.toStringAsFixed(1)}MB', fontSize: 10, color: AppTheme.textDim),
                            ],
                            if (proofKb != null) ...[
                              const SizedBox(width: 14),
                              SIMono('PROOF ${proofKb.toStringAsFixed(2)}KB', fontSize: 10, color: AppTheme.textDim),
                            ],
                          ],
                        ),
                        if (isFailed && r.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SIMono(
                              'ERR: ${r.error}',
                              fontSize: 10,
                              color: AppTheme.danger,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (!_isExecuting)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.border)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SIMono('SUCCESS: $_completedCount', color: AppTheme.success),
                        SIMono('FAILED: $_failedCount', color: AppTheme.danger),
                        SIMono('TOTAL: ${_totalStopwatch.elapsed.inSeconds}s', color: AppTheme.text),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _completedCount > 0 && !_isPushing ? _pushToDatabase : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: _completedCount > 0 && !_isPushing ? AppTheme.text : AppTheme.surface2,
                        alignment: Alignment.center,
                        child: _isPushing 
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.background))
                            : SIMono('▸ SEND DATA TO DATABASE', fontSize: 12, letterSpacing: 2, color: _completedCount > 0 ? AppTheme.background : AppTheme.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
