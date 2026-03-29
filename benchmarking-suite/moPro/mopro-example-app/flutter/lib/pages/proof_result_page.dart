import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';
import 'package:battery_plus/battery_plus.dart';

import 'package:Deimos/channels/imp1_channel.dart';
import 'package:Deimos/models/benchmark_item.dart';
import 'package:Deimos/utils/circuit_registry.dart';
import 'package:Deimos/services/api_service.dart';
import 'package:Deimos/services/device_stats_service.dart';
import 'package:Deimos/utils/circuit_utils.dart';
import 'package:Deimos/theme/app_theme.dart';
import 'package:Deimos/widgets/smooth_loading_indicator.dart';

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
  bool _isVerifying = false;
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
  
  // Store Barretenberg verification keys (like in old implementation)
  final Map<String, Uint8List> _noirVerificationKeys = {};
  
  // Benchmarking timing
  Duration? _proofGenerationTime;
  Duration? _proofVerificationTime;
  
  // Memory tracking during proof generation
  int _freeMemoryBeforeProof = 0;
  int _minFreeMemoryDuringProof = 0;
  int _freeMemoryAfterProof = 0;
  int _peakMemoryUsage = 0;
  
  // Battery tracking
  int _batteryBeforeProof = 0;
  int _batteryAfterProof = 0;
  
  // Timer to keep UI responsive
  Timer? _uiUpdateTimer;
  
  // Progress tracking
  String _currentStage = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    // Start a timer to periodically trigger UI updates for smooth animation
    _uiUpdateTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted && _isGenerating) {
        setState(() {
          // Force rebuild to keep animation smooth
        });
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.framework.toUpperCase()} - ${widget.algorithm}'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputDisplay(),
                    const SizedBox(height: 24),
                    _buildProofSection(),
                    const SizedBox(height: 24),
                    _buildVerificationSection(),
                    const SizedBox(height: 24),
                    _buildBenchmarkingSection(),
                    const SizedBox(height: 24),
                    _buildResultsSection(),
                  ],
                ),
              ),
            ),
            // Show a full-screen loading overlay when first entering the page
            if (_isGenerating && _proofData == null)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Generating Proof',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This might take a while',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 8,
                            backgroundColor: AppTheme.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Framework: ${widget.framework.toUpperCase()}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Algorithm: ${widget.algorithm}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Input: ${widget.selectedInputName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              '[${widget.selectedInputData.values.join(', ')}]',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProofSection() {
    // Don't show this section while generating (overlay handles it)
    if (_isGenerating && _proofData == null) {
      return const SizedBox.shrink();
    }
    
    return _buildCard(
      title: 'Proof Generation',
      child: Column(
        children: [
          if (_proofData != null)
            const Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                SizedBox(width: 12),
                Text('Proof generated successfully'),
              ],
            )
          else if (_error != null)
            Row(
            children: [
                const Icon(Icons.error, color: AppTheme.danger, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: $_error')),
              ],
            )
          else
            const Text('Ready to generate proof'),
        ],
      ),
    );
  }
  
  Widget _buildVerificationSection() {
    return _buildCard(
      title: 'Proof Verification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_proofData == null)
            const Text('Generate proof first')
          else if (_isVerifying)
            Row(
              children: const [
                SmoothLoadingIndicator(
                  size: 24,
                  strokeWidth: 2.5,
                  color: AppTheme.primary,
                ),
                SizedBox(width: 12),
                Text(
                  'Verifying proof...',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else if (_isValid != null)
            Row(
              children: [
                Icon(
                  _isValid! ? Icons.check_circle : Icons.cancel,
                  color: _isValid! ? AppTheme.success : AppTheme.danger,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(_isValid! ? 'Proof verified successfully' : 'Proof verification failed'),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyProof,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Verify Proof',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_proofData == null) return const SizedBox.shrink();

    return _buildCard(
      title: 'Proof Data',
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
              color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                _proofData!,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: AppTheme.text,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildProofDetails(),
        ],
      ),
    );
  }
  
  Widget _buildBenchmarkingSection() {
    return _buildCard(
      title: 'Benchmarking Results',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_proofGenerationTime != null)
            _buildTimingRow(
              'Proof Generation',
              _proofGenerationTime!,
              Icons.timer,
              Colors.blue,
            ),
          if (_proofVerificationTime != null)
            _buildTimingRow(
              'Proof Verification',
              _proofVerificationTime!,
              Icons.verified,
              Colors.green,
            ),
          if (_proofGenerationTime != null && _proofVerificationTime != null)
            _buildTimingRow(
              'Total Time',
              Duration(
                milliseconds: _proofGenerationTime!.inMilliseconds + 
                           _proofVerificationTime!.inMilliseconds
              ),
              Icons.speed,
              Colors.orange,
            ),
        ],
      ),
    );
  }
  
  Widget _buildTimingRow(String label, Duration duration, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
            children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              _formatDuration(duration),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    if (duration.inSeconds > 0) {
      return '${duration.inSeconds}.${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}s';
    } else {
      return '${duration.inMilliseconds}ms';
    }
  }
  
  Widget _buildProofDetails() {
    switch (widget.framework.toLowerCase()) {
      case 'groth16':
        return _buildCircomProofDetails();
      case 'barretenberg':
        return _buildNoirProofDetails();
      case 'risc0':
        return _buildRisc0ProofDetails();
      case 'cairo':
        return _buildCairoProofDetails();
      case 'provekit':
        return _buildProveKitProofDetails();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCircomProofDetails() {
    if (_circomProofResult == null) return const SizedBox.shrink();
    
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          'Proof Details:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text('Protocol: ${_circomProofResult!.proof.protocol}'),
        Text('Curve: ${_circomProofResult!.proof.curve}'),
        Text('Public Signals: ${_circomProofResult!.inputs.toString()}'),
        const SizedBox(height: 8),
              Text(
          'Proof Points:',
          style: TextStyle(
            fontSize: 14,
                  fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text('π_a: [${_circomProofResult!.proof.a.x}, ${_circomProofResult!.proof.a.y}, ${_circomProofResult!.proof.a.z}]'),
        Text('π_b.x: [${_circomProofResult!.proof.b.x.join(', ')}]'),
        Text('π_b.y: [${_circomProofResult!.proof.b.y.join(', ')}]'),
        Text('π_b.z: [${_circomProofResult!.proof.b.z.join(', ')}]'),
        Text('π_c: [${_circomProofResult!.proof.c.x}, ${_circomProofResult!.proof.c.y}, ${_circomProofResult!.proof.c.z}]'),
      ],
    );
  }

  Widget _buildNoirProofDetails() {
    if (_noirProofResult == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof Details:',
            style: TextStyle(
            fontSize: 16,
              fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text('Proof Size: ${_noirProofResult!.length} bytes'),
        Text('Algorithm: ${widget.algorithm}'),
      ],
    );
  }

  Widget _buildRisc0ProofDetails() {
    if (_risc0ProofResult == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof Details:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text('Receipt size: ${(_risc0ProofResult!.receipt.length / 1024).toStringAsFixed(1)} KB'),
        if (_risc0VerifyResult != null) ...[
            const SizedBox(height: 16),
            Text('Verification: ${_risc0VerifyResult!.isValid ? "PASSED" : "FAILED"}'),
            const SizedBox(height: 4),
            Text('Output value: ${_risc0VerifyResult!.outputValue}'),
          ],
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
                style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
                ),
              ),
          const SizedBox(height: 16),
          child,
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
      
      // Generate actual proof using MoPro framework 
      _proofData = await _generateRealProof();
      
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
  }



  Future<String> _generateGroth16Proof(MoproFlutter plugin) async {
    // Get input data based on algorithm (special case for Poseidon)
    final inputData = _getInputDataForAlgorithm();
    final inputs = _inputDataToByteArrayJson(inputData);
    
    // Get the appropriate zkey path based on algorithm
    final zkeyAssetPath = CircuitUtils.getZkeyPath(widget.algorithm, widget.selectedInputName);

    // Capture memory and battery BEFORE proof generation
    final memSnapshotBefore = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
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
    
    // Capture memory and battery AFTER proof generation
    final memSnapshotAfter = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryAfterProof = memSnapshotAfter.free;
    _batteryAfterProof = await battery.batteryLevel;
    
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
    
    // Capture memory and battery BEFORE proof generation
    final memSnapshotBefore = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
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
    
    // Capture memory and battery AFTER proof generation
    final memSnapshotAfter = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryAfterProof = memSnapshotAfter.free;
    _batteryAfterProof = await battery.batteryLevel;
    
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
    
    // Capture memory and battery BEFORE proof generation
    final memSnapshotBefore = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using actual MoPro
    final proofResult = await plugin.generateRisc0Proof(numericInput);
    
    // Stop timing and store
    stopwatch.stop();
    
    // Capture memory and battery AFTER proof generation
    final memSnapshotAfter = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryAfterProof = memSnapshotAfter.free;
    _batteryAfterProof = await battery.batteryLevel;
    
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
    
    // Capture memory and battery BEFORE proof generation
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using IMP1
    final proofResult = await IMP1Channel.generateProof(
      circuitName: circuitName,
    );
    
    // Stop timing
    stopwatch.stop();
    
    // Capture memory and battery AFTER proof generation
    _freeMemoryAfterProof = SysInfo.getFreePhysicalMemory();
    _batteryAfterProof = await battery.batteryLevel;
    
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


  void _verifyProof() async {
    setState(() {
      _isVerifying = true;
    });
    
    // Give the UI a chance to update and show the loading indicator
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      // Perform actual verification using MoPro framework
      final isValid = await _performRealVerification();
      
      // Update UI immediately after verification
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isValid = isValid;
        });
      }
      
      // Send data to backend asynchronously without blocking UI
      if (isValid) {
        _sendDataToBackend().catchError((error) {
          debugPrint('Error sending data to backend: $error');
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { 
          _isVerifying = false;
          _isValid = false;
          _error = e.toString();
        });
      }
    }
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
      print('✗ Error in sending data: $e');
    }
  }
  
  Future<Map<String, dynamic>> _collectSystemInfo() async {
    try {
      // Get memory information
      final memSnapshot = await DeviceStatsService.getMemorySnapshot();
      final totalPhysicalMemory = memSnapshot.total;
      
      // Calculate memory used during proof generation
      final memoryUsedBeforeProof = totalPhysicalMemory - _freeMemoryBeforeProof;
      final memoryUsedAfterProof = totalPhysicalMemory - _freeMemoryAfterProof;
      
      // Calculate memory consumed by proof generation
      final memoryConsumedByProof = _peakMemoryUsage - memoryUsedBeforeProof;
      
      return {
        'memory': {
          'totalPhysicalMemory': totalPhysicalMemory,
          
          // Memory BEFORE proof generation
          'memoryUsedBeforeProof': memoryUsedBeforeProof,
          
          // Memory DURING proof generation (peak usage)
          'peakMemoryUsage': _peakMemoryUsage,
          
          // Memory consumed specifically by proof generation
          'memoryConsumedByProof': memoryConsumedByProof,

          // Peak memory load during percentage
          'peakMemoryLoadInPercentage': totalPhysicalMemory > 0 
              ? (_peakMemoryUsage / totalPhysicalMemory * 100) 
              : 0.0,

          // Memory consumed percentage
          'memoryConsumedInPercentage': totalPhysicalMemory > 0 
              ? (memoryConsumedByProof / totalPhysicalMemory * 100) 
              : 0.0,
        },
        'battery': {
          'batteryBeforeProof': _batteryBeforeProof,
          'batteryAfterProof': _batteryAfterProof,
          'batteryConsumed': _batteryBeforeProof - _batteryAfterProof,
        },
      };
    } catch (e) {
      // Silently handle errors and return minimal info
      return {
        'memory': {'error': e.toString()},
      };
    }
  }
  
  // Monitor memory usage during proof generation
  void _startMemoryMonitoring() {
    _peakMemoryUsage = 0;
    _minFreeMemoryDuringProof = 0;
    
    // Sample memory every 100ms during proof generation
    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (_isGenerating) {
        // Skip memory monitoring on non-Android platforms, except iOS now supported
        if (!Platform.isAndroid && !Platform.isIOS) return;
        
        final memSnapshot = await DeviceStatsService.getMemorySnapshot();
        final currentUsedMemory = memSnapshot.total - memSnapshot.free;
        
        // Track peak memory usage
        if (currentUsedMemory > _peakMemoryUsage) {
          _peakMemoryUsage = currentUsedMemory;
          _minFreeMemoryDuringProof = memSnapshot.free;
        }
      } else {
        timer.cancel();
      }
    });
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
    
    // Capture memory and battery BEFORE proof generation
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;

    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();

    final proofResult = await plugin.generateCairoProof(
      programPath,
      inputsJson,
      entrypoint
    );

    stopwatch.stop();
    // Capture memory and battery AFTER proof generation
    _freeMemoryAfterProof = SysInfo.getFreePhysicalMemory();
    _batteryAfterProof = await battery.batteryLevel;

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

  Widget _buildCairoProofDetails() {
    if (_cairoProofResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof Details:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text('Proof Size: ${_cairoProofResult!.proof.length} bytes'),
        if (_cairoVerifyResult != null) ...[
          const SizedBox(height: 16),
          Text('Verification: ${_cairoVerifyResult!.isValid ? "PASSED" : "FAILED"}'),
        ],
      ],
    );
  }

  Future<String> _generateProveKitProof(MoproFlutter plugin) async {
    final circuitName = CircuitUtils.getProveKitCircuitName(widget.algorithm, widget.selectedInputName);
    final pkpPath = 'assets/provekit/$circuitName.pkp';
    
    // Prepare input as TOML
    final inputValues = _getInputDataForAlgorithm();
    final inputToml = 'input = [${inputValues.map((v) => '"$v"').join(', ')}]\n';

    final memSnapshotBefore = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    final stopwatch = Stopwatch()..start();
    _startMemoryMonitoring();
    
    final proofResult = await plugin.generateProveKitProof(pkpPath, inputToml);
    
    stopwatch.stop();
    final memSnapshotAfter = await DeviceStatsService.getMemorySnapshot();
    _freeMemoryAfterProof = memSnapshotAfter.free;
    _batteryAfterProof = await battery.batteryLevel;
    
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

  Widget _buildProveKitProofDetails() {
    if (_provekitProofResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof Details:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text('Proof Size: ${_provekitProofResult!.proof.length} bytes'),
        if (_provekitVerifyResult != null) ...[
          const SizedBox(height: 16),
          Text('Verification: ${_provekitVerifyResult!.isValid ? "PASSED" : "FAILED"}'),
        ],
      ],
    );
  }
}
