import 'package:flutter/material.dart';
import 'dart:async';
import '../models/benchmark_item.dart';
import '../services/benchmark_service.dart';
import '../utils/circuit_registry.dart';
import '../services/api_service.dart';
import '../services/device_stats_service.dart';

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
    });
    _totalStopwatch.start();

    for (int i = 0; i < _results.length; i++) {
      if (!mounted) break;

      final item = _results[i];
      // Find appropriate input data
      final inputData = _findInputForitem(item);

      // Update status to Proving
      setState(() {
        _results[i] = item.copyWith(status: BenchmarkStatus.proving);
      });
      _scrollToItem(i);

      // Run benchmark
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
    }

    _totalStopwatch.stop();
    if (mounted) {
      setState(() {
        _isExecuting = false;
      });
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
        index * 72.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _results.length > 0 ? (_completedCount + _failedCount) / _results.length : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Execution Dashboard'),
        actions: [
          if (!_isExecuting)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _results = CircuitRegistry.getFullBenchmarkSuite();
                });
                _startBatch();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressHeader(progress),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return _buildResultTile(_results[index]);
              },
            ),
          ),
          if (!_isExecuting) _buildSummaryFooter(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress: ${(_completedCount + _failedCount)}/${_results.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _failedCount > 0 ? Colors.orange : Colors.blue,
            ),
          ),
          if (_isExecuting) ...[
            const SizedBox(height: 10),
            const Text('Executing batch sequentially...', style: TextStyle(fontStyle: FontStyle.italic)),
          ]
        ],
      ),
    );
  }

  Widget _buildResultTile(BenchmarkResult result) {
    IconData statusIcon;
    Color statusColor;
    Widget trailing = const SizedBox.shrink();

    switch (result.status) {
      case BenchmarkStatus.pending:
        statusIcon = Icons.hourglass_empty;
        statusColor = Colors.grey;
        break;
      case BenchmarkStatus.proving:
        statusIcon = Icons.settings;
        statusColor = Colors.blue;
        trailing = const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
        break;
      case BenchmarkStatus.verifying:
        statusIcon = Icons.verified_user_outlined;
        statusColor = Colors.cyan;
        trailing = const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
        break;
      case BenchmarkStatus.completed:
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        trailing = Text('${result.provingTime?.inMilliseconds}ms / ${result.verificationTime?.inMilliseconds}ms');
        break;
      case BenchmarkStatus.failed:
        statusIcon = Icons.error;
        statusColor = Colors.red;
        trailing = IconButton(
          icon: const Icon(Icons.info_outline, size: 20),
          onPressed: () => _showError(result.error),
        );
        break;
    }

    return ListTile(
      leading: Icon(statusIcon, color: statusColor),
      title: Text('${CircuitRegistry.getFrameworkDisplayName(result.framework)} - ${result.algorithm}'),
      subtitle: Text(result.status.name.toUpperCase()),
      trailing: trailing,
    );
  }

  Widget _buildSummaryFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Total', _results.length.toString()),
              _buildStat('Success', _completedCount.toString(), color: Colors.green),
              _buildStat('Failed', _failedCount.toString(), color: Colors.red),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Total Time: ${_totalStopwatch.elapsed.inSeconds}.${(_totalStopwatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}s',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (_isPushing)
             const CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: _completedCount > 0 ? _pushToDatabase : null,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Send Data to Database'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                 minimumSize: const Size(double.infinity, 50),
              ),
            ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
             style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Future<void> _pushToDatabase() async {
    setState(() {
      _isPushing = true;
    });

    final deviceInfo = await DeviceStatsService.collectDeviceInfo({}); // We can pass a basic system info if needed, but it's handled inside device_stats_service now
    
    int pushSuccess = 0;
    int pushFailed = 0;

    for (final result in _results) {
       if (result.status == BenchmarkStatus.completed) {
         final inputData = _findInputForitem(result);
         final customInputs = {
           result.inputName: '[${inputData.values.join(', ')}]'
         };

         final benchmarkData = {
          'circuit': result.algorithm,
          'framework': 'MoPro',
          'language': result.framework,
          'provingTimeMiliSeconds': result.provingTime?.inMilliseconds ?? 0,
          'verificationTimeMiliSeconds': result.verificationTime?.inMilliseconds ?? 0,
          'deviceInfo': deviceInfo,
          'memory': result.memoryInfo,
          'battery': result.batteryInfo,
          'proofSize': result.proofSize,
          'customInputs': customInputs,
          'proofBackend': (result.framework == 'arkworks' || result.framework == 'rapidsnark') ? result.framework : 'N/A',
          'timestamp': DateTime.now().toIso8601String(),
         };

         final success = await ApiService.sendBenchmarkData(benchmarkData);
         if (success) {
           pushSuccess++;
         } else {
           pushFailed++;
         }
       }
    }

    setState(() {
      _isPushing = false;
    });

    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database Push: $pushSuccess successful, $pushFailed failed.'),
          backgroundColor: pushFailed > 0 ? Colors.orange : Colors.green,
        ),
      );
    }
  }

  Widget _buildStat(String label, String value, {Color? color}) {

    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void _showError(String? error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Benchmark Error'),
        content: Text(error ?? 'Unknown error'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
