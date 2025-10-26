import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';

// Design constants based on design.json
class AppTheme {
  static const Color primary = Color(0xFF5B56E6);
  static const Color secondary = Color(0xFF1E40AF);
  static const Color accent = Color(0xFF00BCD4);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFA500);
  static const Color success = Color(0xFF10B981);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deimos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppTheme.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainSelectionPage(),
    );
  }
}

class MainSelectionPage extends StatefulWidget {
  const MainSelectionPage({super.key});

  @override
  State<MainSelectionPage> createState() => _MainSelectionPageState();
}

class _MainSelectionPageState extends State<MainSelectionPage> {
  // Selection state
  String? _selectedFramework;
  String? _selectedAlgorithm;
  final TextEditingController _customInputController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _customInputController.text = "Hello World! This is a test msg.";
  }

  @override
  void dispose() {
    _customInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFrameworkSelection(),
              const SizedBox(height: 24),
              _buildAlgorithmSelection(),
              const SizedBox(height: 24),
              _buildCustomInput(),
              const SizedBox(height: 32),
              _buildRunButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'D',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      'Deimos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'ZK Proof Benchmarking',
              style: TextStyle(
                fontSize: 16,
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
              ),
            ],
              ),
            ],
          ),
    );
  }

  Widget _buildFrameworkSelection() {
    return _buildCard(
      title: 'Select Framework',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          const Text(
            'Choose a ZK proof framework',
              style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFrameworkButton(
                  'Circom',
                  Icons.speed,
                  'circom',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFrameworkButton(
                  'Halo2',
                  Icons.layers,
                  'halo2',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFrameworkButton(
                  'Noir',
                  Icons.nightlight_round,
                  'noir',
                ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFrameworkButton(String label, IconData icon, String value) {
    final isSelected = _selectedFramework == value;
    return GestureDetector(
      onTap: () {
                        setState(() {
          _selectedFramework = value;
          _selectedAlgorithm = null; // Reset algorithm when framework changes
                      });
                    },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 2,
          ),
        ),
        child: Column(
              children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgorithmSelection() {
    if (_selectedFramework == null) {
      return const SizedBox.shrink();
    }

    final algorithms = _getAlgorithmsForFramework(_selectedFramework!);
    
    return _buildCard(
      title: 'Select Algorithm',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose a hashing algorithm',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: algorithms.map((algorithm) {
              final isSelected = _selectedAlgorithm == algorithm;
              return GestureDetector(
                onTap: () {
                      setState(() {
                    _selectedAlgorithm = algorithm;
                      });
                    },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.border,
                    ),
                  ),
                  child: Text(
                    algorithm,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppTheme.text,
                    ),
                  ),
                ),
              );
            }).toList(),
                ),
              ],
            ),
    );
  }

  Widget _buildCustomInput() {
    return _buildCard(
      title: 'Custom Input',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter text to hash',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _customInputController,
            decoration: InputDecoration(
              hintText: 'Enter your custom text here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildRunButton() {
    final canRun = _selectedFramework != null && _selectedAlgorithm != null;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canRun ? _runBenchmark : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canRun ? AppTheme.primary : AppTheme.border,
          foregroundColor: canRun ? Colors.white : AppTheme.textSecondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: canRun ? 2 : 0,
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Generating Proof...'),
                ],
              )
            : Text(
                canRun 
                    ? 'Run ${_selectedFramework!.toUpperCase()} - $_selectedAlgorithm'
                    : 'Select Framework & Algorithm',
                style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

  List<String> _getAlgorithmsForFramework(String framework) {
    switch (framework) {
      case 'circom':
        return ['SHA256', 'Keccak256', 'Blake2s256', 'MiMC256', 'Pedersen', 'Poseidon'];
      case 'halo2':
        return ['Fibonacci'];
      case 'noir':
        return ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Pedersen'];
      default:
        return [];
    }
  }

  void _runBenchmark() async {
    if (_selectedFramework == null || _selectedAlgorithm == null) return;

                      setState(() {
      _isLoading = true;
    });

    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProofResultPage(
            framework: _selectedFramework!,
            algorithm: _selectedAlgorithm!,
            customInput: _customInputController.text,
          ),
        ),
      );
    }

                        setState(() {
      _isLoading = false;
    });
  }
}

// Stage 2: Proof Result Page
class ProofResultPage extends StatefulWidget {
  final String framework;
  final String algorithm;
  final String customInput;

  const ProofResultPage({
    super.key,
    required this.framework,
    required this.algorithm,
    required this.customInput,
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
  CircomProofResult? _circomProofResult;
  Halo2ProofResult? _halo2ProofResult;
  Uint8List? _noirProofResult;
  
  // Store Noir verification keys (like in old implementation)
  Uint8List? _noirMimcVerificationKey;
  Uint8List? _noirKeccakVerificationKey;
  Uint8List? _noirPoseidonVerificationKey;
  Uint8List? _noirPedersenVerificationKey;
  Uint8List? _noirSha256VerificationKey;
  
  // Benchmarking timing
  Duration? _proofGenerationTime;
  Duration? _proofVerificationTime;

  @override
  void initState() {
    super.initState();
    _generateProof();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              _buildInputDisplay(),
              const SizedBox(height: 24),
              _buildProofSection(),
              const SizedBox(height: 24),
              _buildVerificationSection(),
              const SizedBox(height: 24),
              _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputDisplay() {
    return _buildCard(
      title: 'Input',
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
          const SizedBox(height: 12),
                const Text(
            'Custom Input:',
                  style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
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
              '"${widget.customInput}"',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppTheme.text,
              ),
            ),
            ),
        ],
      ),
    );
  }

  Widget _buildProofSection() {
    return _buildCard(
      title: 'Proof Generation',
      child: Column(
        children: [
          if (_isGenerating)
            const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Generating proof...'),
              ],
            )
          else if (_proofData != null)
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
              children: [
          if (_proofData == null)
            const Text('Generate proof first')
          else if (_isVerifying)
            const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Verifying proof...'),
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
              Text(
                  _isValid! ? 'Proof is valid' : 'Proof is invalid',
                  style: TextStyle(
                    color: _isValid! ? AppTheme.success : AppTheme.danger,
                    fontWeight: FontWeight.w600,
                ),
              ),
            ],
            )
          else
            ElevatedButton(
              onPressed: _verifyProof,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
              ),
              child: const Text('Verify Proof'),
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
          // Show benchmarking results
          _buildBenchmarkingSection(),
          const SizedBox(height: 16),
          // Show additional proof details based on framework
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
      case 'circom':
        return _buildCircomProofDetails();
      case 'halo2':
        return _buildHalo2ProofDetails();
      case 'noir':
        return _buildNoirProofDetails();
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
        Text('π_b: [${_circomProofResult!.proof.b.x.join(', ')}, ${_circomProofResult!.proof.b.y.join(', ')}, ${_circomProofResult!.proof.b.z.join(', ')}]'),
        Text('π_c: [${_circomProofResult!.proof.c.x}, ${_circomProofResult!.proof.c.y}, ${_circomProofResult!.proof.c.z}]'),
      ],
    );
  }

  Widget _buildHalo2ProofDetails() {
    if (_halo2ProofResult == null) return const SizedBox.shrink();
    
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
        Text('Proof Size: ${_halo2ProofResult!.proof.length} bytes'),
        Text('Inputs: ${_halo2ProofResult!.inputs.toString()}'),
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
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      // Generate actual proof using MoPro framework
      _proofData = await _generateRealProof();
      
      setState(() {
        _isGenerating = false;
      });
            } catch (e) {
      setState(() {
        _isGenerating = false;
        _error = e.toString();
      });
    }
  }

  Future<String> _generateRealProof() async {
    final moproFlutterPlugin = MoproFlutter();
    
    switch (widget.framework.toLowerCase()) {
      case 'circom':
        return await _generateCircomProof(moproFlutterPlugin);
      case 'halo2':
        return await _generateHalo2Proof(moproFlutterPlugin);
      case 'noir':
        return await _generateNoirProof(moproFlutterPlugin);
      default:
        throw Exception('Unknown framework: ${widget.framework}');
    }
  }

  Future<String> _generateCircomProof(MoproFlutter plugin) async {
    // Convert user input to proper format
    final inputs = _textToByteArrayJson(widget.customInput);
    
    // Get the appropriate zkey path based on algorithm
    final zkeyPath = _getZkeyPath();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Generate proof using actual MoPro
    final proofResult = await plugin.generateCircomProof(
      zkeyPath, 
      inputs, 
      ProofLib.arkworks
    );
    
    // Stop timing and store
    stopwatch.stop();
    
    if (proofResult == null) {
      throw Exception('Failed to generate Circom proof');
    }
    
    // Store the proof result for verification
    setState(() {
      _circomProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    // Format the actual proof data
    return _formatCircomProofOutput(proofResult);
  }

  Future<String> _generateHalo2Proof(MoproFlutter plugin) async {
    // Validate and convert user input to Halo2 format
    int? numericInput = int.tryParse(widget.customInput);
    if (numericInput == null) {
      throw Exception('Input for Halo2 Fibonacci circuit must be a numeric value');
    }
    final inputs = {
      "out": [numericInput]
    };
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Generate proof using actual MoPro
    final proofResult = await plugin.generateHalo2Proof(
      "assets/plonk_fibonacci_srs.bin",
      "assets/plonk_fibonacci_pk.bin", 
      inputs
    );
    
    // Stop timing and store
    stopwatch.stop();
    
    if (proofResult == null) {
      throw Exception('Failed to generate Halo2 proof');
    }
    
    // Store the proof result for verification
    setState(() {
      _halo2ProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    // Format the actual proof data
    return _formatHalo2ProofOutput(proofResult);
  }

  Future<String> _generateNoirProof(MoproFlutter plugin) async {
    // Convert custom input to Noir format (32-byte padded byte array)
    final List<String> customInputs = _textToNoirInput(widget.customInput);
    
    // Get the appropriate circuit path and settings
    final (circuitPath, srsPath, onChain, vk) = await _getNoirSettings();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Generate proof using actual MoPro with custom inputs
    final proof = await plugin.generateNoirProof(
      circuitPath,
      srsPath,
      customInputs,
      onChain,
      vk,
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

  String _getZkeyPath() {
    switch (widget.algorithm.toLowerCase()) {
      case 'sha256':
        return "assets/sha256.zkey";
      case 'keccak256':
        return "assets/keccak.zkey";
      case 'blake2s256':
        return "assets/blake2s256.zkey";
      case 'mimc256':
        return "assets/mimc256.zkey";
      case 'pedersen':
        return "assets/pedersen.zkey";
      case 'poseidon':
        return "assets/poseidon.zkey";
      default:
        return "assets/sha256.zkey";
    }
  }

  Future<(String, String, bool, Uint8List)> _getNoirSettings() async {
    final moproFlutterPlugin = MoproFlutter();
    const bool lowMemoryMode = false;
      
      String assetPath;
      String srsPath;
      bool onChain;
      Uint8List? verificationKey;
    
    switch (widget.algorithm.toLowerCase()) {
      case 'sha256':
        assetPath = "assets/sha256.json";
        srsPath = "assets/sha256.srs";
          onChain = true;
        if (_noirSha256VerificationKey == null) {
            try {
            final vkAsset = await rootBundle.load('assets/sha256.vk');
            _noirSha256VerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirSha256VerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
        verificationKey = _noirSha256VerificationKey;
          break;
      case 'keccak256':
          assetPath = "assets/keccak256.json";
          srsPath = "assets/keccak256.srs";
          onChain = true;
          if (_noirKeccakVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/keccak.vk');
              _noirKeccakVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirKeccakVerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirKeccakVerificationKey;
          break;
      case 'poseidon':
          assetPath = "assets/poseidon.json";
          srsPath = "assets/poseidon.srs";
          onChain = false;
          if (_noirPoseidonVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/poseidon.vk');
              _noirPoseidonVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirPoseidonVerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirPoseidonVerificationKey;
          break;
      case 'mimc':
        assetPath = "assets/mimc.json";
        srsPath = "assets/mimc.srs";
        onChain = true;
        if (_noirMimcVerificationKey == null) {
          try {
            final vkAsset = await rootBundle.load('assets/mimc.vk');
            _noirMimcVerificationKey = vkAsset.buffer.asUint8List();
          } catch (e) {
            _noirMimcVerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
              assetPath, srsPath, onChain, lowMemoryMode,
            );
          }
        }
        verificationKey = _noirMimcVerificationKey;
        break;
      case 'pedersen':
          assetPath = "assets/pedersen.json";
          srsPath = "assets/pedersen.srs";
          onChain = true;
          if (_noirPedersenVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/pedersen.vk');
              _noirPedersenVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirPedersenVerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirPedersenVerificationKey;
          break;
      default:
          assetPath = "assets/sha256.json";
          srsPath = "assets/sha256.srs";
          onChain = true;
          if (_noirSha256VerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/sha256.vk');
              _noirSha256VerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirSha256VerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirSha256VerificationKey;
          break;
    }
    
    return (assetPath, srsPath, onChain, verificationKey!);
  }

  String _formatCircomProofOutput(CircomProofResult proofResult) {
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
Input: "${widget.customInput}"
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }

  String _formatHalo2ProofOutput(Halo2ProofResult proofResult) {
    return '''
${widget.algorithm} Proof: Halo2ProofResult(
  proof: ${proofResult.proof.toString()}
  inputs: ${proofResult.inputs.toString()}
)

Framework: ${widget.framework}
Algorithm: ${widget.algorithm}
Input: "${widget.customInput}"
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
Input: "${widget.customInput}"
Timestamp: ${DateTime.now().millisecondsSinceEpoch}
''';
  }





  String _textToByteArrayJson(String text) {
    // Convert text to 32-byte padded UTF-8 byte array for Circom
    final bytes = utf8.encode(text);
    final paddedBytes = List<int>.filled(32, 0);
    for (int i = 0; i < bytes.length && i < 32; i++) {
      paddedBytes[i] = bytes[i];
    }
    return '{"in": [${paddedBytes.map((b) => '"$b"').join(', ')}]}';
  }


  List<String> _textToNoirInput(String text) {
    // Convert text to 32-byte padded UTF-8 byte array for Noir
    final bytes = utf8.encode(text);
    final paddedBytes = List<int>.filled(32, 0);
    for (int i = 0; i < bytes.length && i < 32; i++) {
      paddedBytes[i] = bytes[i];
    }
    return paddedBytes.map((b) => b.toString()).toList();
  }

  void _verifyProof() async {
    setState(() {
      _isVerifying = true;
    });
    
    try {
      // Perform actual verification using MoPro framework
      final isValid = await _performRealVerification();
      
      setState(() {
        _isVerifying = false;
        _isValid = isValid;
      });
    } catch (e) {
      setState(() { 
        _isVerifying = false;
        _isValid = false;
        _error = e.toString();
      });
    }
  }

  Future<bool> _performRealVerification() async {
    final moproFlutterPlugin = MoproFlutter();
    
    switch (widget.framework.toLowerCase()) {
      case 'circom':
        return await _verifyCircomProof(moproFlutterPlugin);
      case 'halo2':
        return await _verifyHalo2Proof(moproFlutterPlugin);
      case 'noir':
        return await _verifyNoirProof(moproFlutterPlugin);
        default:
        throw Exception('Unknown framework: ${widget.framework}');
    }
  }

  Future<bool> _verifyCircomProof(MoproFlutter plugin) async {
    if (_circomProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    final zkeyPath = _getZkeyPath();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final result = await plugin.verifyCircomProof(zkeyPath, _circomProofResult!, ProofLib.arkworks);
    
    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
    });
    
    return result;
  }

  Future<bool> _verifyHalo2Proof(MoproFlutter plugin) async {
    if (_halo2ProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final result = await plugin.verifyHalo2Proof(
      "assets/plonk_fibonacci_srs.bin",
      "assets/plonk_fibonacci_vk.bin",
      _halo2ProofResult!.proof,
      _halo2ProofResult!.inputs
    );
    
    // Stop timing and store
    stopwatch.stop();
      setState(() {
      _proofVerificationTime = stopwatch.elapsed;
    });
    
    return result;
  }

  Future<bool> _verifyNoirProof(MoproFlutter plugin) async {
    if (_noirProofResult == null) {
      throw Exception('No proof available for verification');
    }
    
    final (circuitPath, srsPath, onChain, vk) = await _getNoirSettings();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final result = await plugin.verifyNoirProof(circuitPath, _noirProofResult!, onChain, vk, false);
    
    // Stop timing and store
    stopwatch.stop();
    setState(() {
      _proofVerificationTime = stopwatch.elapsed;
    });
    
    return result;
  }

}

