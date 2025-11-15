import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:system_info2/system_info2.dart';
import 'package:battery_plus/battery_plus.dart';

// Input data structure
class InputData {
  final String name;
  final String description;
  final List<String> values;
  
  InputData({required this.name, required this.description, required this.values});
}


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
  String? _selectedInput;
  bool _isLoading = false;
  bool _isLoadingInputs = true;
  
  List<InputData> _availableInputs = [];

  @override
  void initState() {
    super.initState();
    _loadInputs();
  }

  Future<void> _loadInputs() async {
    try {
      final List<InputData> loadedInputs = [];
      
      // Load input files
      for (int i = 1; i <= 3; i++) {
        try {
          final inputData = await _loadInputFromJson('inputs/input_$i.json');
          loadedInputs.add(inputData);
        } catch (e) {
          debugPrint('Error loading input_$i.json: $e');
        }
      }
      
      setState(() {
        _availableInputs = loadedInputs;
        _isLoadingInputs = false;
        if (_availableInputs.isNotEmpty) {
          _selectedInput = _availableInputs.first.name;
        }
      });
    } catch (e) {
      debugPrint('Error loading inputs: $e');
      setState(() {
        _isLoadingInputs = false;
      });
    }
  }

  Future<InputData> _loadInputFromJson(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract data from JSON
      final String name = jsonData['name'] as String;
      final String description = jsonData['description'] as String;
      final List<dynamic> inArray = jsonData['in'] as List<dynamic>;
      
      // Convert the "in" array to List<String>
      final List<String> values = inArray.map((e) => e.toString()).toList();
      
      return InputData(
        name: name,
        description: description,
        values: values,
      );
    } catch (e) {
      throw Exception('Failed to load input from $assetPath: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingInputs) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading inputs...',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
              const SizedBox(width: 12),
              Expanded(
                child: _buildFrameworkButton(
                  'risc0',
                  Icons.developer_board,
                  'risc0',
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
          _selectedAlgorithm = null;
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
          _buildAlgorithmGrid(algorithms),
              ],
            ),
    );
  }

  Widget _buildCustomInput() {
    if (_availableInputs.isEmpty) {
      return _buildCard(
        title: 'Select Input',
        child: const Text(
          'No inputs available. Please check input files.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      );
    }

    return _buildCard(
      title: 'Select Input',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose a predefined input for benchmarking',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedInput,
                hint: const Text('Select an input'),
                isExpanded: true,
                items: _availableInputs.map((InputData input) {
                  return DropdownMenuItem<String>(
                    value: input.name,
                    child: Text(
                      input.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedInput = newValue;
                  });
                },
              ),
            ),
          ),
          if (_selectedInput != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected: ${_selectedInput}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Input bytes: ${_getSelectedInputPreview()}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAlgorithmGrid(List<String> algorithms) {
    List<Widget> rows = [];
    
    for (int i = 0; i < algorithms.length; i += 3) {
      List<Widget> rowChildren = [];
      
      for (int j = 0; j < 3 && (i + j) < algorithms.length; j++) {
        final algorithm = algorithms[i + j];
        rowChildren.add(
          Expanded(
            child: _buildAlgorithmButton(algorithm),
          ),
        );
        if (j < 2 && (i + j + 1) < algorithms.length) {
          rowChildren.add(const SizedBox(width: 12));
        }
      }
      
      while (rowChildren.length < 5) { 
        rowChildren.add(const Expanded(child: SizedBox()));
      }
      
      rows.add(
        Row(children: rowChildren),
      );
      
      // Add spacing between rows
      if (i + 3 < algorithms.length) {
        rows.add(const SizedBox(height: 12));
      }
    }
    
    return Column(children: rows);
  }

  Widget _buildAlgorithmButton(String algorithm) {
    final isSelected = _selectedAlgorithm == algorithm;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAlgorithm = algorithm;
        });
      },
      child: SizedBox(
        height: 56,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              algorithm,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.text,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  String _getSelectedInputPreview() {
    if (_selectedInput == null) return '';
    final input = _availableInputs.firstWhere((input) => input.name == _selectedInput);
    return _formatInputPreview(input.values);
  }

  String _formatInputPreview(List<String> values, {int maxItems = 1000}) {

    return values.join(', ');
  }

  Widget _buildRunButton() {
    final canRun = _selectedFramework != null && _selectedAlgorithm != null && _selectedInput != null;
    
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
                    : 'Select Framework, Algorithm & Input',
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
        return ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Pedersen', 'Blake2', 'Blake3'];
      case 'risc0':
        return ['Factor'];
      default:
        return [];
    }
  }

  void _runBenchmark() async {
    if (_selectedFramework == null || _selectedAlgorithm == null || _selectedInput == null) return;

    setState(() {
      _isLoading = true;
    });

    if (mounted) {
      // Wait for the ProofResultPage to be popped before setting isLoading to false
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProofResultPage(
            framework: _selectedFramework!,
            algorithm: _selectedAlgorithm!,
            selectedInputName: _selectedInput!,
            selectedInputData: _availableInputs.firstWhere((input) => input.name == _selectedInput!),
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
  CircomProofResult? _circomProofResult;
  Halo2ProofResult? _halo2ProofResult;
  Uint8List? _noirProofResult;
  
  // RISC-V results
  Risc0ProofOutput? _risc0ProofResult;
  Risc0VerifyOutput? _risc0VerifyResult;
  
  // Store Noir verification keys (like in old implementation)
  Uint8List? _noirMimcVerificationKey;
  Uint8List? _noirKeccakVerificationKey;
  Uint8List? _noirPoseidonVerificationKey;
  Uint8List? _noirPedersenVerificationKey;
  Uint8List? _noirSha256VerificationKey;
  Uint8List? _noirBlake2VerificationKey;
  Uint8List? _noirBlake3VerificationKey;
  
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
              _buildBenchmarkingSection(),
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input: ${widget.selectedInputName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bytes: ${widget.selectedInputData.values.join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
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
      case 'risc0':
        return _buildRisc0ProofDetails();
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
      case 'risc0':
        return await _generateRisc0Proof(moproFlutterPlugin);
      default:
        throw Exception('Unknown framework: ${widget.framework}');
    }
  }

  Future<String> _generateCircomProof(MoproFlutter plugin) async {
    // Get input data based on algorithm (special case for Poseidon)
    final inputData = _getInputDataForAlgorithm();
    final inputs = _inputDataToByteArrayJson(inputData);
    
    // Get the appropriate zkey path based on algorithm
    final zkeyPath = _getZkeyPath();
    
    // Capture memory and battery BEFORE proof generation
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using actual MoPro
    final proofResult = await plugin.generateCircomProof(
      zkeyPath, 
            inputs, 
      ProofLib.arkworks
    );
    
    stopwatch.stop();
    
    // Capture memory and battery AFTER proof generation
    _freeMemoryAfterProof = SysInfo.getFreePhysicalMemory();
    _batteryAfterProof = await battery.batteryLevel;
    
    if (proofResult == null) {
      throw Exception('Failed to generate Circom proof');
    }
    
    setState(() {
      _circomProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    return _formatCircomProofOutput(proofResult);
  }

  Future<String> _generateHalo2Proof(MoproFlutter plugin) async {
    // Convert selected input to Halo2 format
    final inputData = _getInputDataForAlgorithm();
    final inputs = {
      "out": [inputData.join(" ")]
    };
    
    // Capture memory and battery BEFORE proof generation
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using actual MoPro
    final proofResult = await plugin.generateHalo2Proof(
      "assets/plonk_fibonacci_srs.bin",
      "assets/plonk_fibonacci_pk.bin", 
      inputs.cast<String, List<String>>()
    );
    
    // Stop timing and store
    stopwatch.stop();
    
    // Capture memory and battery AFTER proof generation
    _freeMemoryAfterProof = SysInfo.getFreePhysicalMemory();
    _batteryAfterProof = await battery.batteryLevel;
    
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
    // Get input data and convert to Noir format
    final inputData = _getInputDataForAlgorithm();
    final List<String> noirInputs = _inputDataToNoirInput(inputData);
    
    // Get the appropriate circuit path and settings
    final (circuitPath, srsPath, onChain, vk) = await _getNoirSettings();
    
    // Capture memory and battery BEFORE proof generation
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using actual MoPro with selected inputs
    final proof = await plugin.generateNoirProof(
      circuitPath,
      srsPath,
      noirInputs,
      onChain,
      vk,
      false // lowMemoryMode
    );
    
    // Stop timing and store
    stopwatch.stop();
    
    // Capture memory and battery AFTER proof generation
    _freeMemoryAfterProof = SysInfo.getFreePhysicalMemory();
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
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
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
    _freeMemoryAfterProof = SysInfo.getFreePhysicalMemory();
    _batteryAfterProof = await battery.batteryLevel;
    
    // Store the proof result for verification
    setState(() {
      _risc0ProofResult = proofResult;
      _proofGenerationTime = stopwatch.elapsed;
    });
    
    // Format the actual proof data
    return _formatRisc0ProofOutput(proofResult);
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
      case 'blake2':
          assetPath = "assets/blake2.json";
          srsPath = "assets/blake2.srs";
          onChain = true;
          if (_noirBlake2VerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/blake2.vk');
              _noirBlake2VerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirBlake2VerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirBlake2VerificationKey;
          break;
      case 'blake3':
          assetPath = "assets/blake3.json";
          srsPath = "assets/blake3.srs";
          onChain = true;
          if (_noirBlake3VerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/blake3.vk');
              _noirBlake3VerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
            _noirBlake3VerificationKey = await moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirBlake3VerificationKey;
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
Input: [${_getInputDataForAlgorithm().join(', ')}]
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
    // Get the selected input data from JSON file
    List<String> inputData = widget.selectedInputData.values;
    
    // Special case for Poseidon: use exactly 8 bytes (as per the circuit requirement)
    if (widget.algorithm.toLowerCase() == 'poseidon') {
      // Take first 8 bytes, pad with zeros if needed
      List<String> poseidonInput = inputData.take(8).toList();
      while (poseidonInput.length < 8) {
        poseidonInput.add('0');
      }
      return poseidonInput;
    }
    
    // Blake2 and Blake3 require exactly 32 bytes input
    final algorithmLower = widget.algorithm.toLowerCase();
    if (algorithmLower == 'blake2' || algorithmLower == 'blake3') {
      List<String> blakeInput = List<String>.from(inputData);
      // Take first 32 bytes, pad with zeros if needed
      if (blakeInput.length > 32) {
        blakeInput = blakeInput.take(32).toList();
      } else {
        while (blakeInput.length < 32) {
          blakeInput.add('0');
        }
      }
      return blakeInput;
    }
    
    return inputData;
  }

  String _inputDataToByteArrayJson(List<String> inputData) {
    // Convert input data to JSON format for Circom
    return '{"in": [${inputData.map((b) => '"$b"').join(', ')}]}';
  }

  List<String> _inputDataToNoirInput(List<String> inputData) {
    // For Noir, we need to pad to 32 bytes if necessary
    final paddedData = List<String>.from(inputData);
    while (paddedData.length < 32) {
      paddedData.add('0');
    }
    // Take only first 32 bytes if longer
    return paddedData.take(32).toList();
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
    
    bool isValid;
    switch (widget.framework.toLowerCase()) {
      case 'circom':
        isValid = await _verifyCircomProof(moproFlutterPlugin);
        break;
      case 'halo2':
        isValid = await _verifyHalo2Proof(moproFlutterPlugin);
        break;
      case 'noir':
        isValid = await _verifyNoirProof(moproFlutterPlugin);
        break;
      case 'risc0':
        isValid = await _verifyRisc0Proof(moproFlutterPlugin);
        break;
      default:
        throw Exception('Unknown framework: ${widget.framework}');
    }
    
    // After verification, send data to backend
    if (isValid) {
      await _sendDataToBackend();
    }
    
    return isValid;
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

  // Collect device information and send to backend
  Future<void> _sendDataToBackend() async {
    try {
      final deviceInfo = await _collectDeviceInfo();
      final benchmarkData = _prepareBenchmarkData(deviceInfo);
      
      print('=== Sending Data to Backend ===');
      print('Data: ${jsonEncode(benchmarkData)}');
      
      // Send to backend API
      final response = await http.post(
        Uri.parse('https://deimos-fork.onrender.com/api/benchmark-result'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(benchmarkData),
      );

      print('=== Backend Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✓ Data successfully sent to backend');
      } else {
        print('✗ Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('✗ Error sending data to backend: $e');
    }
  }
  
  Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};
    
    try {
      // Collect system information (RAM, CPU)
      final systemInfo = await _collectSystemInfo();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'platform': 'Android',
          'device': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'androidVersion': androidInfo.version.release,
          'androidId': androidInfo.id,
          // Add system info
          ...systemInfo,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'platform': 'iOS',
          'device': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'name': iosInfo.name,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'utsname': {
            'machine': iosInfo.utsname.machine,
            'sysname': iosInfo.utsname.sysname,
          },
          // Add system info
          ...systemInfo,
        };
      }
    } catch (e) {
      print('Error collecting device info: $e');
      deviceData = {'platform': 'Unknown', 'error': e.toString()};
    }
    
    return deviceData;
  }
  
  Future<Map<String, dynamic>> _collectSystemInfo() async {
    try {
      // Get memory information
      final totalPhysicalMemory = SysInfo.getTotalPhysicalMemory(); // in bytes
      
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
          'peakMemoryLoadInPercentage': _peakMemoryUsage / totalPhysicalMemory * 100,

          // Memory consumed percentage
          'memoryConsumedInPercentage': memoryConsumedByProof / totalPhysicalMemory * 100,
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
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isGenerating) {
        final currentFreeMemory = SysInfo.getFreePhysicalMemory();
        final currentUsedMemory = SysInfo.getTotalPhysicalMemory() - currentFreeMemory;
        
        // Track peak memory usage
        if (currentUsedMemory > _peakMemoryUsage) {
          _peakMemoryUsage = currentUsedMemory;
          _minFreeMemoryDuringProof = currentFreeMemory;
        }
      } else {
        timer.cancel();
      }
    });
  }
  
  Map<String, dynamic> _prepareBenchmarkData(Map<String, dynamic> deviceInfo) {
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

      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  int _getProofSize() {
    if (_circomProofResult != null) {
      return _proofData?.length ?? 0;
    } else if (_halo2ProofResult != null) {
      return _halo2ProofResult!.proof.length;
    } else if (_noirProofResult != null) {
      return _noirProofResult!.length;
    } else if (_risc0ProofResult != null) {
      return _risc0ProofResult!.receipt.length;
    }
    return 0;
  }

}

