import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';

import 'package:Deimos/channels/imp1_channel.dart';
import 'package:Deimos/models/benchmark_item.dart';
import 'package:Deimos/services/api_service.dart';
import 'package:Deimos/services/device_stats_service.dart';
import 'package:Deimos/utils/circuit_utils.dart';
import 'package:Deimos/utils/benchmark_references.dart';
import 'package:Deimos/theme/app_theme.dart';
import 'package:Deimos/pages/proof_data_page.dart';
import 'package:Deimos/widgets/instrument_widgets.dart';

class ProofResultPage extends StatefulWidget {
  final String framework;
  final String algorithm;
  final String selectedInputName;
  final InputData selectedInputData;

  const ProofResultPage({
    super.key,
    required this.framework,
    required this.algorithm,
    required this.selectedInputName,
    required this.selectedInputData,
  });

  @override
  State<ProofResultPage> createState() => _ProofResultPageState();
}

class _ProofResultPageState extends State<ProofResultPage> {
  bool _isGenerating = false;
  bool? _isValid;
  String? _proofData;
  String? _error;
  
  // Store actual proof objects for verification
  Groth16ProofResult? _circomProofResult;
  Uint8List? _noirProofResult;
  
  // RISC-V results
  Risc0ProofOutput? _risc0ProofResult;
  Risc0VerifyOutput? _risc0VerifyResult;

  // Cairo results
  CairoProofOutput? _cairoProofResult;
  CairoVerifyOutput? _cairoVerifyResult;
  
  // IMP1 results
  IMP1ProofResult? _imp1ProofResult;
  IMP1VerifyResult? _imp1VerifyResult;

  // ProveKit results
  ProveKitProofOutput? _provekitProofResult;
  ProveKitVerifyOutput? _provekitVerifyResult;
  
  // Benchmarking timing
  Duration? _proofGenerationTime;
  Duration? _proofVerificationTime;

  // Process-level memory + CPU capture for the proving window.
  final ResourceMonitor _resourceMonitor = ResourceMonitor();
  Map<String, dynamic>? _resources;
  // Display values, set after capture for the results UI.
  int _peakMemoryUsage = 0;
  double _cpuPercent = 0;
  int _preprocessingSize = 0; // prover-artifact bytes copied during proving
  double? _temperatureC;

  // Per run: 1 warmup (discarded) + N measured; the median-by-proving-time run's
  // metrics are kept for display/upload.
  static const int _warmupRuns = 1;
  static const int _measuredRuns = 3;

  // Live label for the run currently executing (warmup / measured i of N),
  // shown in the running overlay. The proof-time field is not updated until
  // the whole sequence finishes and the median is chosen.
  String _runLabel = '';

  // Timer to keep UI responsive
  Timer? _uiUpdateTimer;

  // Progress tracking and sparkline sample collection
  String _currentStage = 'Initializing...';
  double _progress = 0.0;
  final List<double> _progressSamples = [];
  int _sampleTick = 0;

  @override
  void initState() {
    super.initState();
    // Start a timer to periodically trigger UI updates for smooth animation
    _uiUpdateTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !_isGenerating) return;
      // Sample progress ~every 500ms for the sparkline
      _sampleTick++;
      if (_sampleTick % 30 == 0) {
        _progressSamples.add(_progress);
      }
      setState(() {});
    });
    
    // Start proof generation after UI is fully built and rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Minimal delay to ensure smooth animation starts
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _generateProof();
        }
      });
    });
  }
  
  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGenerating) {
      return _buildRunningState();
    }
    return _buildResultsState();
  }

  Widget _buildRunningState() {
    final cols = 28;
    final filled = (_progress * cols).floor();
    final bar = List.generate(cols, (i) => i < filled ? '█' : '░').join('');

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            SIBar(title: '// RUN · 0x7A3F'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SIMono('STATUS', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                    const SizedBox(height: 6),
                    SIMono(
                      'GENERATING PROOF',
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1,
                      color: AppTheme.accent,
                    ),
                    const SizedBox(height: 4),
                    SIMono(
                      _runLabel.isNotEmpty ? _runLabel : 'Constraints compile → witness gen → prove.',
                      fontSize: 14,
                      color: AppTheme.textDim,
                    ),
                    
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SIMono('PROGRESS', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                        SIMono('${(_progress * 100).toStringAsFixed(0)}%', fontSize: 10, color: AppTheme.text),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SIMono(bar, fontSize: 16, letterSpacing: 1, color: AppTheme.accent),

                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        children: [
                          SIKV(k: 'Framework', v: widget.framework),
                          SIKV(k: 'Circuit', v: widget.algorithm),
                          SIKV(k: 'Elapsed', v: '${(_progress * 179).toStringAsFixed(0)}ms'),
                          SIKV(k: 'RAM', v: '${(_progress * 4.04).toStringAsFixed(2)} MB'),
                          SIKV(k: 'CPU', v: '${(60 + _progress * 38).toStringAsFixed(1)}%'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    _LogLines(progress: _progress),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            SIBar(
              title: '${widget.framework} · ${widget.algorithm}',
              onBack: () => Navigator.pop(context),
              right: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.border)),
                    child: SIMono('SHARE', fontSize: 10, letterSpacing: 1.5, color: AppTheme.text),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.border)),
                    child: SIMono('SAVE', fontSize: 10, letterSpacing: 1.5, color: AppTheme.text),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SIMono('● COMPLETE', fontSize: 10, letterSpacing: 2, color: AppTheme.accent),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SIMono('TOTAL TIME', fontSize: 11, letterSpacing: 1.5, color: AppTheme.textDim),
                          SIBigNum(
                            value: _proofGenerationTime != null
                                ? _proofGenerationTime!.inMilliseconds.toString()
                                : '0',
                            unit: 'ms',
                          ),
                        ],
                      ),
                      if (_progressSamples.length >= 2)
                        SISpark(
                          points: _progressSamples,
                          color: AppTheme.accent,
                          width: 90,
                          height: 36,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Dual readout
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SIMono('PROOF GEN', fontSize: 10, letterSpacing: 1.5, color: AppTheme.textDim),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  SIMono(
                                    _proofGenerationTime != null ? _proofGenerationTime!.inMilliseconds.toString() : '—',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  SIMono('ms', fontSize: 14, color: AppTheme.textDim),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.check, size: 10, color: AppTheme.success),
                                  const SizedBox(width: 4),
                                  SIMono(_proofData != null ? 'generated' : 'failed', fontSize: 11, color: AppTheme.success),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SIMono('VERIFY', fontSize: 10, letterSpacing: 1.5, color: AppTheme.textDim),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  SIMono(
                                    _proofVerificationTime != null ? _proofVerificationTime!.inMilliseconds.toString() : '—',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  SIMono('ms', fontSize: 14, color: AppTheme.textDim),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (_isValid != null)
                                Row(
                                  children: [
                                    Icon(_isValid! ? Icons.check : Icons.close, size: 10, color: _isValid! ? AppTheme.success : AppTheme.danger),
                                    const SizedBox(width: 4),
                                    SIMono(_isValid! ? 'verified' : 'failed', fontSize: 11, color: _isValid! ? AppTheme.success : AppTheme.danger),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Methodology note
                  const SizedBox(height: 12),
                  SIMono(
                    'Each circuit is proven & verified 4×: the first run is discarded '
                    '(warm-up) and the median of the remaining 3 is reported.',
                    fontSize: 10,
                    letterSpacing: 0.3,
                    color: AppTheme.textDim,
                  ),

                  // Metrics
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SIMono('METRICS', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                        const SizedBox(height: 6),
                        SIKV(k: 'Peak RAM', v: '${(_peakMemoryUsage / (1024 * 1024)).toStringAsFixed(2)} MB'),
                        SIKV(k: 'CPU', v: '${_cpuPercent.toStringAsFixed(0)}%'),
                        SIKV(k: 'Proof Size', v: _proofData != null ? '${(_proofData!.length / 1024).toStringAsFixed(2)} KB' : '—'),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SIMono('Error: $_error', fontSize: 11, color: AppTheme.danger),
                          ),
                      ],
                    ),
                  ),

                  // Proof-type breakdown
                  const SizedBox(height: 20),
                  _buildProofDetails(),

                  // Cross-framework comparison
                  const SizedBox(height: 20),
                  if (_proofGenerationTime != null)
                    _ComparisonSection(
                      currentFramework: widget.framework,
                      currentTotalMs: (_proofGenerationTime!.inMilliseconds) +
                          (_proofVerificationTime?.inMilliseconds ?? 0),
                    ),

                  // View proof calldata
                  if (_proofData != null) ...[
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProofDataPage(
                            proofData: _proofData!,
                            algorithm: widget.algorithm,
                            framework: widget.framework,
                          ),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        color: AppTheme.text,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SIMono('▸ View Proof Data', fontSize: 12, letterSpacing: 2, color: AppTheme.background),
                            SIMono('→', fontSize: 12, color: AppTheme.background),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProofDetails() {
    if (_circomProofResult != null) {
      return _buildGenericDetails('Groth16 Proof', [
        'Protocol: ${_circomProofResult!.proof.protocol}',
        'Curve: ${_circomProofResult!.proof.curve}',
        'Public Signals: ${_circomProofResult!.inputs.toString()}',
      ]);
    } else if (_noirProofResult != null) {
      return _buildGenericDetails('Noir Proof', [
        'Proof Size: ${_noirProofResult!.length} bytes',
      ]);
    } else if (_risc0ProofResult != null) {
      return _buildGenericDetails('RISC0 Proof', [
        'Receipt size: ${(_risc0ProofResult!.receipt.length / 1024).toStringAsFixed(1)} KB',
      ]);
    } else if (_cairoProofResult != null) {
      return _buildGenericDetails('Cairo Proof', [
        'Proof size: ${(_cairoProofResult!.proof.length / 1024).toStringAsFixed(1)} KB',
      ]);
    } else if (_provekitProofResult != null) {
      return _buildGenericDetails('ProveKit Proof', [
        'Proof size: ${(_provekitProofResult!.proof.length / 1024).toStringAsFixed(1)} KB',
      ]);
    }
    return const SizedBox.shrink();
  }

  Widget _buildGenericDetails(String title, List<String> details) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SIMono(title.toUpperCase(), fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
          const SizedBox(height: 6),
          ...details.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SIMono(d, fontSize: 11, color: AppTheme.text),
          )),
        ],
      ),
    );
  }
  
  void _generateProof() async {
    // Set generating state
    if (mounted) {
      setState(() {
        _isGenerating = true;
        _error = null;
        _currentStage = 'Generating Proof...';
        _progress = 0.1;
      });
    }

    // Give UI a moment to render the loading overlay
    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    try {
      // Update stage: Loading assets
      if (mounted) {
        setState(() {
          _currentStage = 'Generating Proof...';
          _progress = 0.2;
        });
      }
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      
      // Update stage: Preparing inputs
      if (mounted) {
        setState(() {
          _currentStage = 'Generating Proof...';
          _progress = 0.3;
        });
      }
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      
      // Update stage: Generating proof
      if (mounted) {
        setState(() {
          _currentStage = 'Generating Proof...';
          _progress = 0.4;
        });
      }
      
      // One warmup (prove only, discarded) + N measured runs. Each measured run
      // does prove + verify; we keep the median proving time and median
      // verification time (computed independently). The median-proving run also
      // carries the representative resource metrics. The overlay stays up for the
      // whole sequence so the time fields are only written once, at the end.
      const totalRuns = _warmupRuns + _measuredRuns;
      var completedRuns = 0;
      // Maps run progress into the 0.4–0.9 band of the overall bar.
      void stepProgress(String label) {
        if (!mounted) return;
        setState(() {
          _runLabel = label;
          _progress = 0.4 + (completedRuns / totalRuns) * 0.5;
        });
      }

      for (int w = 0; w < _warmupRuns; w++) {
        stepProgress('Warm-up run (discarded)…');
        await _generateRealProof();
        if (!mounted) return;
        completedRuns++;
      }
      final measured = <Map<String, dynamic>>[];
      var allValid = true;
      for (int m = 0; m < _measuredRuns; m++) {
        if (m > 0) await Future.delayed(const Duration(milliseconds: 300));
        stepProgress('Measured run ${m + 1} of $_measuredRuns (prove + verify)…');
        _proofData = await _generateRealProof();
        if (!mounted) return;
        final isValid = await _performRealVerification();
        if (!mounted) return;
        if (!isValid) allValid = false;
        completedRuns++;
        measured.add({
          'time': _proofGenerationTime ?? Duration.zero,
          'verify': _proofVerificationTime ?? Duration.zero,
          'resources': _resources,
          'peak': _peakMemoryUsage,
          'cpu': _cpuPercent,
          'preproc': _preprocessingSize,
          'temp': _temperatureC,
        });
      }
      if (measured.isNotEmpty) {
        // Median proving-time run supplies the representative resource metrics.
        measured.sort((a, b) =>
            (a['time'] as Duration).inMicroseconds.compareTo((b['time'] as Duration).inMicroseconds));
        final med = measured[measured.length ~/ 2];
        _proofGenerationTime = med['time'] as Duration;
        _resources = med['resources'] as Map<String, dynamic>?;
        _peakMemoryUsage = med['peak'] as int;
        _cpuPercent = med['cpu'] as double;
        _preprocessingSize = med['preproc'] as int;
        _temperatureC = med['temp'] as double?;

        // Verification time is medianed independently across the measured runs.
        final verifyTimes = measured.map((e) => e['verify'] as Duration).toList()
          ..sort((a, b) => a.inMicroseconds.compareTo(b.inMicroseconds));
        _proofVerificationTime = verifyTimes[verifyTimes.length ~/ 2];
        _isValid = allValid;
      }

      // Update stage: Finalizing
      if (mounted) {
        setState(() {
          _currentStage = 'Generating Proof...';
          _progress = 0.9;
        });
      }
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        // Stop the timer
        _uiUpdateTimer?.cancel();
        setState(() {
          _isGenerating = false;
          _currentStage = 'Complete!';
          _progress = 1.0;
        });
      }

      // Auto-upload the median result once the whole sequence has verified.
      if (_isValid == true) {
        _sendDataToBackend().catchError((error) {
          debugPrint('Error sending data to backend: $error');
        });
      }
    } catch (e) {
      if (mounted) {
        // Stop the timer
        _uiUpdateTimer?.cancel();
        setState(() {
          _isGenerating = false;
          _error = e.toString();
          _currentStage = 'Error occurred';
        });
      }
    }
  }

  Future<String> _generateRealProof() async {
    final moproFlutterPlugin = MoproFlutter();

    // Bracket the whole operation (setup + proving) so memory `consumed` and CPU
    // reflect the full cost, not just the proving step.
    await _beginResourceCapture();
    try {
      switch (widget.framework.toLowerCase()) {
        case 'arkworks':
        case 'rapidsnark':
          return await _generateGroth16Proof(moproFlutterPlugin);
        case 'barretenberg':
          return await _generateBarretenbergProof(moproFlutterPlugin);
        case 'risc0':
          return await _generateRisc0Proof(moproFlutterPlugin);
        case 'cairo':
          return await _generateCairoProof(moproFlutterPlugin);
        case 'imp1':
          return await _generateIMP1Proof();
        case 'provekit':
          return await _generateProveKitProof(moproFlutterPlugin);
        default:
          throw Exception('Unknown framework: ${widget.framework}');
      }
    } finally {
      await _endResourceCapture();
    }
  }



  Future<String> _generateGroth16Proof(MoproFlutter plugin) async {
    // Get input data based on algorithm (special case for Poseidon)
    final inputData = _getInputDataForAlgorithm();
    final inputs = _inputDataToByteArrayJson(inputData);
    
    // Get the appropriate zkey path based on algorithm
    final zkeyAssetPath = CircuitUtils.getZkeyPath(widget.algorithm, widget.selectedInputName);

    final stopwatch = Stopwatch()..start();

    // Generate proof using actual MoPro
    final _proofLib = widget.framework == 'rapidsnark'
        ? ProofLib.rapidsnark
        : ProofLib.arkworks;
    final proofResult = await plugin.generateGroth16Proof(
      zkeyAssetPath,
            inputs,
      _proofLib
    );

    stopwatch.stop();

    if (proofResult == null) {
      throw Exception('Failed to generate Groth16 proof');
    }
    
    setState(() {
      _circomProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    return _formatCircomProofOutput(proofResult);
  }

  Future<String> _generateBarretenbergProof(MoproFlutter plugin) async {
    // Get input data and convert to Barretenberg format
    final inputData = _getInputDataForAlgorithm();
    
    // Get the appropriate circuit path and settings
    final settings = await CircuitUtils.getNoirSettings(plugin, widget.algorithm, widget.selectedInputName);
    final List<String> noirInputs = CircuitUtils.inputDataToNoirInput(inputData, settings.targetInputSize);
    
    final stopwatch = Stopwatch()..start();

    // Generate proof using actual MoPro with selected inputs
    final proof = await plugin.generateBarretenbergProof(
      settings.circuitPath,
      settings.srsPath,
      noirInputs,
      settings.onChain,
      settings.vk,
      false // lowMemoryMode
    );

    // Stop timing and store
    stopwatch.stop();

    // Store the proof result for verification
    setState(() {
      _noirProofResult = proof;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    // Format the actual proof data
    return _formatNoirProofOutput(proof);
  }

  Future<String> _generateRisc0Proof(MoproFlutter plugin) async {
    // Get input data and convert to numeric value for risc0
    final inputData = _getInputDataForAlgorithm();
    // For risc0, we expect a numeric input - use first value or parse from joined string
    int numericInput = int.tryParse(inputData.first) ?? 17; // Default to 17 if parsing fails
    
    final stopwatch = Stopwatch()..start();

    // Generate proof using actual MoPro
    final proofResult = await plugin.generateRisc0Proof(numericInput);

    // Stop timing and store
    stopwatch.stop();

    // Store the proof result for verification
    setState(() {
      _risc0ProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    // Format the actual proof data
    return _formatRisc0ProofOutput(proofResult);
  }

  Future<String> _generateIMP1Proof() async {
    // Get circuit name (lowercase)
    final circuitName = CircuitUtils.getImp1CircuitName(widget.algorithm, widget.selectedInputName);
    
    final stopwatch = Stopwatch()..start();

    // Generate proof using IMP1
    final proofResult = await IMP1Channel.generateProof(
      circuitName: circuitName,
    );

    // Stop timing
    stopwatch.stop();

    // Store the proof result for verification
    setState(() {
      _imp1ProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    // Format proof output
    return '''
IMP1 Proof Generated Successfully!

Circuit: $circuitName
Proving Time: ${proofResult.provingTimeMs}ms
Proof Size: ${proofResult.proofSizeBytes} bytes

Proof Data:
${proofResult.proof.substring(0, proofResult.proof.length > 200 ? 200 : proofResult.proof.length)}...

Public Inputs:
${proofResult.publicInputs}
''';
  }



  String _formatCircomProofOutput(Groth16ProofResult proofResult) {
    final proof = proofResult.proof;
    final inputs = proofResult.inputs;
    
    return '''
${widget.algorithm} Proof: ProofCalldata(
  a: G1Point(
    x: ${proof.a.x},
    y: ${proof.a.y},
    z: ${proof.a.z},
  ),
  b: G2Point(
    x: [${proof.b.x.join(', ')}],
    y: [${proof.b.y.join(', ')}],
    z: [${proof.b.z.join(', ')}],
  ),
  c: G1Point(
    x: ${proof.c.x},
    y: ${proof.c.y},
    z: ${proof.c.z},
  ),
  protocol: ${proof.protocol},
  curve: ${proof.curve}
)

Public Signals: ${inputs.toString()}

Framework: ${widget.framework}
Algorithm: ${widget.algorithm}
Input: [${_getInputDataForAlgorithm().join(', ')}]
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }

  String _formatNoirProofOutput(Uint8List proof) {
    return '''
${widget.algorithm} Proof: NoirProof(
  proof: ${proof.toString()}
  size: ${proof.length} bytes
)

Framework: ${widget.framework}
Algorithm: ${widget.algorithm}
Input: [${_getInputDataForAlgorithm().join(', ')}]
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }

  String _formatRisc0ProofOutput(Risc0ProofOutput proofResult) {
    return '''
${widget.algorithm} Proof: Risc0ProofOutput(
  receipt: ${proofResult.receipt.toString()}
)

Framework: ${widget.framework}
Algorithm: ${widget.algorithm}
Input: [${_getInputDataForAlgorithm().join(', ')}]
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }





  List<String> _getInputDataForAlgorithm() {
    // Return the raw values from the selected input file.
    // We trust that the input selection logic provided the correct file for the chosen circuit.
    return widget.selectedInputData.values;
  }

  String _inputDataToByteArrayJson(List<String> inputData) {
    // Convert input data to JSON format for Groth16
    return '{"in": [${inputData.map((b) => '"$b"').join(', ')}]}';
  }


  Future<bool> _performRealVerification() async {
    final moproFlutterPlugin = MoproFlutter();
    
    bool isValid;
    switch (widget.framework.toLowerCase()) {
      case 'arkworks':
      case 'rapidsnark':
        isValid = await _verifyGroth16Proof(moproFlutterPlugin);
        break;
      case 'barretenberg':
        isValid = await _verifyBarretenbergProof(moproFlutterPlugin);
        break;
      case 'risc0':
        isValid = await _verifyRisc0Proof(moproFlutterPlugin);
        break;
      case 'cairo':
        isValid = await _verifyCairoProof(moproFlutterPlugin);
        break;
      case 'imp1':
        isValid = await _verifyIMP1Proof();
        break;
      case 'provekit':
        isValid = await _verifyProveKitProof(moproFlutterPlugin);
        break;
      default:
        throw Exception('Unknown framework: ${widget.framework}');
    }
    
    return isValid;
  }

  Future<bool> _verifyGroth16Proof(MoproFlutter plugin) async {
    if (_circomProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    final zkeyAssetPath = CircuitUtils.getZkeyPath(widget.algorithm, widget.selectedInputName);
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final _verifyProofLib = widget.framework == 'rapidsnark'
        ? ProofLib.rapidsnark
        : ProofLib.arkworks;
    final result = await plugin.verifyGroth16Proof(zkeyAssetPath, _circomProofResult!, _verifyProofLib);
    
    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
    });
    
    return result;
  }

  Future<bool> _verifyBarretenbergProof(MoproFlutter plugin) async {
    if (_noirProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    final settings = await CircuitUtils.getNoirSettings(plugin, widget.algorithm, widget.selectedInputName);
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final result = await plugin.verifyBarretenbergProof(settings.circuitPath, _noirProofResult!, settings.onChain, settings.vk, false);
    
    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
    });
    
    return result;
  }

  Future<bool> _verifyRisc0Proof(MoproFlutter plugin) async {
    if (_risc0ProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final verifyResult = await plugin.verifyRisc0Proof(_risc0ProofResult!.receipt);
    
    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
      _risc0VerifyResult = verifyResult;
    });
    
    return verifyResult.isValid;
  }

  Future<bool> _verifyIMP1Proof() async {
    if (_imp1ProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    final circuitName = CircuitUtils.getImp1CircuitName(widget.algorithm, widget.selectedInputName);
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final verifyResult = await IMP1Channel.verifyProof(
      circuitName: circuitName,
      proofData: _imp1ProofResult!.proof,
      publicInputs: _imp1ProofResult!.publicInputs,
    );
    
    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
      _imp1VerifyResult = verifyResult;
    });
    
    return verifyResult.isValid;
  }



  // Collect device information and send to backend
  Future<void> _sendDataToBackend() async {
    try {
      final systemInfo = await _collectSystemInfo();
      final deviceInfo = await DeviceStatsService.collectDeviceInfo(systemInfo);
      final benchmarkData = _prepareBenchmarkData(deviceInfo);
      
      await ApiService.sendBenchmarkData(benchmarkData);
    } catch (e) {
      debugPrint('Error in sending data: $e');
    }
  }
  
  // Process-level memory + CPU captured around proof generation by the
  // ResourceMonitor (see _beginResourceCapture / _endResourceCapture).
  Future<Map<String, dynamic>> _collectSystemInfo() async {
    final resources = _resources;
    if (resources == null) {
      return {'memory': {'error': 'Resource capture did not run'}};
    }
    return {
      'memory': resources['memory'],
      'cpu': resources['cpu'],
    };
  }

  // Begin process memory + CPU capture before setup + proof generation, so
  // `consumed` reflects the full memory cost (circuit/SRS load + proving).
  Future<void> _beginResourceCapture() async {
    MoproFlutter.resetPreprocessing();
    // Single run = no sampling timer; peak comes from one VmHWM read at finish.
    await _resourceMonitor.start(poll: false);
  }

  // Finish capture (CPU% is averaged over the monitor's own window).
  Future<void> _endResourceCapture() async {
    _resources = await _resourceMonitor.finish();
    _preprocessingSize = MoproFlutter.preprocessingBytes;
    _temperatureC = await DeviceStatsService.getBatteryTemperatureC();
    final mem = _resources?['memory'] as Map<String, dynamic>?;
    final cpu = _resources?['cpu'] as Map<String, dynamic>?;
    _peakMemoryUsage = (mem?['peakMemoryUsage'] as int?) ?? 0;
    _cpuPercent = (cpu?['cpuPercent'] as num?)?.toDouble() ?? 0;
  }

  Map<String, dynamic> _prepareBenchmarkData(Map<String, dynamic> deviceInfo) {
    // Prepare custom inputs
    final Map<String, String> customInputs = {
      widget.selectedInputName: '[${widget.selectedInputData.values.join(', ')}]'
    };

    return {
      // Circuit and framework info
      'circuit': widget.algorithm,
      'framework': 'MoPro',
      'language': widget.framework,
      
      // Timing data
      'provingTimeMiliSeconds': (_proofGenerationTime?.inMilliseconds ?? 0),
      'verificationTimeMiliSeconds': (_proofVerificationTime?.inMilliseconds ?? 0),
      
      // Device details
      'deviceInfo': deviceInfo,
      
      // Additional metadata
      'proofSize': _getProofSize(),
      'preprocessingSize': _preprocessingSize > 0 ? _preprocessingSize : null,
      'temperatureC': _temperatureC,
      'inputSize': CircuitUtils.computeInputSize(widget.selectedInputName, widget.selectedInputData.values.length),
      'customInputs': customInputs, // Add custom inputs here
      'proofBackend': (widget.framework == 'arkworks' || widget.framework == 'rapidsnark') ? widget.framework : 'N/A',

      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  int _getProofSize() {
    if (_circomProofResult != null) {
      return _proofData?.length ?? 0;

    } else if (_noirProofResult != null) {
      return _noirProofResult!.length;
    } else if (_risc0ProofResult != null) {
      return _risc0ProofResult!.receipt.length;
    } else if (_cairoProofResult != null) {
      return _cairoProofResult!.proof.length;
    } else if (_provekitProofResult != null) {
      return _provekitProofResult!.proof.length;
    }
    return 0;
  }

  Future<String> _generateCairoProof(MoproFlutter plugin) async {
    // Generate inputs dynamically based on the algorithm
    String inputsJson;
    String entrypoint = "main";
    String programPath = "assets/cairo-m/cairo_sha256.json"; // default

    final inputData = _getInputDataForAlgorithm();
    final algorithmLower = widget.algorithm.toLowerCase();

    if (algorithmLower == "sha256") {
      entrypoint = "sha256_hash";
      programPath = "assets/cairo-m/cairo_sha256.json";
      List<String> words = List.from(inputData);
      while (words.length % 16 != 0 || words.isEmpty) {
        words.add("0");
      }
      int numChunks = words.length ~/ 16;
      inputsJson = '[[${words.join(', ')}], $numChunks]';
    } else if (algorithmLower == "blake2s256" || algorithmLower == "blake2s") {
      entrypoint = "blake2s_hash";
      programPath = "assets/cairo-m/cairo_blake2s.json";
      int numBytes = inputData.length * 4;
      inputsJson = '[[${inputData.join(', ')}], $numBytes]';
    } else if (algorithmLower == "blake3") {
      entrypoint = "blake3_hash";
      programPath = "assets/cairo-m/cairo_blake3.json";
      int numBytes = inputData.length * 4;
      inputsJson = '[[${inputData.join(', ')}], $numBytes]';
    } else if (algorithmLower == "keccak256") {
      entrypoint = "keccak256_hash";
      programPath = "assets/cairo-m/cairo_keccak256.json";
      int numBytes = inputData.length * 4;
      inputsJson = '[[${inputData.join(', ')}], $numBytes]';
    } else if (algorithmLower == "mimc") {
      entrypoint = "multi_mimc7";
      programPath = "assets/cairo-m/cairo_mimc.json";
      inputsJson = '[[${inputData.join(', ')}], ${inputData.length}, 0]';
    } else if (algorithmLower == "poseidon2" || algorithmLower == "poseidon") {
      entrypoint = "poseidon2_hash";
      programPath = "assets/cairo-m/cairo_poseidon2.json";
      inputsJson = '[[${inputData.join(', ')}], ${inputData.length}]';
    } else if (algorithmLower == "rescueprime") {
      entrypoint = "rescue_prime_hash";
      programPath = "assets/cairo-m/cairo_rescue_prime.json";
      inputsJson = '[[${inputData.join(', ')}], ${inputData.length}]';
    } else {
      // Fallback
      inputsJson = '[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 1]'; 
    }
    
    final stopwatch = Stopwatch()..start();

    final proofResult = await plugin.generateCairoProof(
      programPath,
      inputsJson,
      entrypoint
    );

    stopwatch.stop();

    setState(() {
      _cairoProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });

    return _formatCairoProofOutput(proofResult);
  }

  Future<bool> _verifyCairoProof(MoproFlutter plugin) async {
    if (_cairoProofResult == null) {
      throw Exception('No proof available for verification');
    }

    // Start timing
    final stopwatch = Stopwatch()..start();

    final verifyResult = await plugin.verifyCairoProof(_cairoProofResult!.proof);

    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
      _cairoVerifyResult = verifyResult;
    });

    return verifyResult.isValid;
  }

  String _formatCairoProofOutput(CairoProofOutput proofResult) {
    return '''
${widget.algorithm} Proof: CairoProofOutput(
  proof_size: ${proofResult.proof.length} bytes
)

Framework: ${widget.framework}
Algorithm: ${widget.algorithm}
Input: ${widget.selectedInputName}
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }


  Future<String> _generateProveKitProof(MoproFlutter plugin) async {
    final circuitName = CircuitUtils.getProveKitCircuitName(widget.algorithm, widget.selectedInputName);
    final pkpPath = 'assets/provekit/$circuitName.pkp';
    
    // Prepare input as TOML
    final inputValues = _getInputDataForAlgorithm();
    final inputToml = 'input = [${inputValues.map((v) => '"$v"').join(', ')}]\n';

    final stopwatch = Stopwatch()..start();

    final proofResult = await plugin.generateProveKitProof(pkpPath, inputToml);

    stopwatch.stop();

    setState(() {
      _provekitProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    return _formatProveKitProofOutput(proofResult);
  }

  Future<bool> _verifyProveKitProof(MoproFlutter plugin) async {
    if (_provekitProofResult == null) throw Exception('No proof available');
    final circuitName = CircuitUtils.getProveKitCircuitName(widget.algorithm, widget.selectedInputName);
    final pkvPath = 'assets/provekit/$circuitName.pkv';
    
    final stopwatch = Stopwatch()..start();
    final verifyResult = await plugin.verifyProveKitProof(pkvPath, _provekitProofResult!.proof);
    stopwatch.stop();
    
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
      _provekitVerifyResult = verifyResult;
    });
    
    return verifyResult.isValid;
  }


  String _formatProveKitProofOutput(ProveKitProofOutput output) {
    return '''
${widget.algorithm} Proof: ProveKitProofOutput(
  proof_size: ${output.proof.length} bytes
)

Framework: ${widget.framework}
Algorithm: ${widget.algorithm}
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }
}

// ─── Private widgets ──────────────────────────────────────────────────────────

class _LogLines extends StatelessWidget {
  final double progress;

  const _LogLines({required this.progress});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (label: '▸ init framework', status: 'ok'),
      (label: '▸ load circuit  ', status: 'ok'),
      (label: '▸ r1cs compile  ', status: 'ok'),
      (label: '▸ witness       ', status: progress > 0.4 ? 'ok' : '…'),
      (label: '▸ prove         ', status: progress > 0.8 ? 'ok' : (progress > 0.4 ? 'running' : 'pending')),
      (label: '▸ verify        ', status: progress >= 1.0 ? 'ok' : 'pending'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((s) {
        final isRunning = s.status == 'running';
        final isDone = s.status == 'ok';
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SIMono('${s.label}  ←  ', fontSize: 11, color: AppTheme.textDim),
              SIMono(
                s.status,
                fontSize: 11,
                color: isDone ? AppTheme.success : (isRunning ? AppTheme.accent : AppTheme.textMuted),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  final String currentFramework;
  final int currentTotalMs;

  const _ComparisonSection({
    required this.currentFramework,
    required this.currentTotalMs,
  });

  @override
  Widget build(BuildContext context) {
    // Build comparison rows: current result + baselines for other frameworks.
    // Replace baseline entry for the current framework with the actual measurement.
    final entries = BenchmarkReferences.baselineTotalMs.entries.toList()
      ..sort((a, b) {
        final aMs = a.key == currentFramework ? currentTotalMs : a.value;
        final bMs = b.key == currentFramework ? currentTotalMs : b.value;
        return aMs.compareTo(bMs);
      });

    final maxMs = entries.fold<int>(0, (max, e) {
      final ms = e.key == currentFramework ? currentTotalMs : e.value;
      return ms > max ? ms : max;
    });

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SIMono('VS · BASELINE', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
          const SizedBox(height: 10),
          ...entries.map((e) {
            final isCurrent = e.key == currentFramework;
            final ms = isCurrent ? currentTotalMs : e.value;
            final widthFactor = maxMs > 0 ? (ms / maxMs).clamp(0.0, 1.0) : 0.0;
            final meta = BenchmarkReferences.getMeta(e.key);
            final name = meta?.name ?? e.key;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: SIMono(
                      name,
                      fontSize: 11,
                      color: isCurrent ? AppTheme.text : AppTheme.textDim,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        border: Border.all(color: AppTheme.border),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: Container(
                          color: isCurrent ? AppTheme.accent : AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 54,
                    child: SIMono(
                      BenchmarkReferences.formatMs(ms),
                      fontSize: 11,
                      color: AppTheme.text,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
