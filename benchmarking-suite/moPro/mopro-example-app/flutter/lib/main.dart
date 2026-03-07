import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:system_info2/system_info2.dart';
import 'package:battery_plus/battery_plus.dart';

// IMP1 Integration
import 'package:Deimos/channels/imp1_channel.dart';

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
  final List<InputData> _bytesInputs = [];
  final List<InputData> _fieldInputsNoir = [];
  final List<InputData> _fieldInputsCircom = [];

  @override
  void initState() {
    super.initState();
    _loadInputs();
  }

  Future<void> _loadInputs() async {
    try {
      // Load Bytes inputs - all available sizes
      final byteSizes = ['16', '32', '64', '128', '256', '512', '1028'];
      for (var size in byteSizes) {
        try {
          final inputData = await _loadInputFromJson(
            'inputs/bytes/input$size.json',
            name: 'Input $size',
            description: '$size bytes input',
          );
          _bytesInputs.add(inputData);
        } catch (e) {
          debugPrint('Error loading inputs/bytes/input$size.json: $e');
        }
      }

      // Load Field inputs for Barretenberg
      final fieldSizesNoir = ['1f', '2f', '3f', '5f', '9f', '17f', '34f'];
      for (var size in fieldSizesNoir) {
        try {
          final inputData = await _loadInputFromJson(
            'inputs/field_elements/input$size.json',
            name: 'Input $size',
            description: '$size field elements input',
          );
          _fieldInputsNoir.add(inputData);
        } catch (e) {
          debugPrint('Error loading inputs/field_elements/input$size.json: $e');
        }
      }

      // Load Field inputs for Groth16
      final fieldSizesCircom = ['16f', '32f', '64f', '128f'];
      for (var size in fieldSizesCircom) {
        try {
          final inputData = await _loadInputFromJson(
            'inputs/field_elements/input$size.json',
            name: 'Input $size',
            description: '$size field elements input',
          );
          _fieldInputsCircom.add(inputData);
        } catch (e) {
          debugPrint('Error loading inputs/field_elements/input$size.json: $e');
        }
      }
      
      setState(() {
        _isLoadingInputs = false;
        // Don't set _availableInputs here, it depends on selection
      });
    } catch (e) {
      debugPrint('Error loading inputs: $e');
      setState(() {
        _isLoadingInputs = false;
      });
    }
  }

  Future<InputData> _loadInputFromJson(String assetPath, {String? name, String? description}) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract data from JSON
      final String finalName = name ?? (jsonData['name'] as String? ?? 'Unknown');
      final String finalDescription = description ?? (jsonData['description'] as String? ?? '');
      final List<dynamic> inArray = jsonData['in'] as List<dynamic>;
      
      // Convert the "in" array to List<String>
      final List<String> values = inArray.map((e) => e.toString()).toList();
      
      return InputData(
        name: finalName,
        description: finalDescription,
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
    final frameworks = [
      {'name': 'Groth16', 'value': 'groth16', 'icon': Icons.speed},
      {'name': 'Barretenberg', 'value': 'barretenberg', 'icon': Icons.nightlight_round},
      {'name': 'RISC Zero', 'value': 'risc0', 'icon': Icons.developer_board},
      {'name': 'Cairo', 'value': 'cairo', 'icon': Icons.architecture},
      {'name': 'IMP1', 'value': 'imp1', 'icon': Icons.flash_on},
      {'name': 'ProveKit', 'value': 'provekit', 'icon': Icons.security},
    ];

    return _buildCard(
      title: 'Step 1: Select Framework',
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: _selectedFramework != null 
                  ? AppTheme.primary.withOpacity(0.05)
                  : AppTheme.surface,
              border: Border.all(
                color: _selectedFramework != null 
                    ? AppTheme.primary 
                    : AppTheme.border, 
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFramework,
                hint: Row(
                  children: const [
                    Icon(Icons.code, size: 20, color: AppTheme.textSecondary),
                    SizedBox(width: 12),
                    Text(
                      'Select a framework',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                items: frameworks.map((framework) {
                  return DropdownMenuItem<String>(
                    value: framework['value'] as String,
                    child: Row(
                      children: [
                        Icon(
                          framework['icon'] as IconData,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          framework['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.text,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFramework = newValue;
                    _selectedAlgorithm = null; // Reset algorithm when framework changes
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAlgorithmSelection() {
    final isEnabled = _selectedFramework != null;
    final algorithms = isEnabled ? _getAlgorithmsForFramework(_selectedFramework!) : <String>[];
    
    return _buildCard(
      title: 'Step 2: Select Circuit',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnabled 
                ? 'Choose a circuit for benchmarking'
                : 'Select a framework first to enable circuit selection',
            style: TextStyle(
              fontSize: 14,
              color: isEnabled ? AppTheme.textSecondary : AppTheme.textSecondary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: isEnabled ? 1.0 : 0.5,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _selectedAlgorithm != null 
                    ? AppTheme.accent.withOpacity(0.05)
                    : AppTheme.surface,
                border: Border.all(
                  color: _selectedAlgorithm != null 
                      ? AppTheme.accent 
                      : AppTheme.border, 
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAlgorithm,
                  hint: Row(
                    children: [
                      Icon(
                        Icons.memory, 
                        size: 20, 
                        color: isEnabled ? AppTheme.textSecondary : AppTheme.textSecondary.withOpacity(0.4),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Select a circuit',
                        style: TextStyle(
                          fontSize: 16,
                          color: isEnabled ? AppTheme.textSecondary : AppTheme.textSecondary.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down, 
                    color: isEnabled ? AppTheme.primary : AppTheme.primary.withOpacity(0.3),
                  ),
                  items: isEnabled ? algorithms.map((algorithm) {
                    return DropdownMenuItem<String>(
                      value: algorithm,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            algorithm,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.text,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList() : null,
                  onChanged: isEnabled ? (String? newValue) {
                    setState(() {
                      _selectedAlgorithm = newValue;
                      _updateAvailableInputs();
                    });
                  } : null,
                ),
              ),
            ),
          ),
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
      title: 'Step 3: Select Input',
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
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedInput,
                hint: Row(
                  children: const [
                    Icon(Icons.input, size: 20, color: AppTheme.textSecondary),
                    SizedBox(width: 12),
                    Text(
                      'Select an input',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                items: _availableInputs.map((InputData input) {
                  return DropdownMenuItem<String>(
                    value: input.name,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.data_object,
                          size: 18,
                          color: AppTheme.accent,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          input.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.text,
                          ),
                        ),
                      ],
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
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Input Data',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getSelectedInputPreview(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }


  String _getSelectedInputPreview() {
    if (_selectedInput == null) return '';
    final input = _availableInputs.firstWhere((input) => input.name == _selectedInput);
    return _formatInputPreview(input.values);
  }

  String _formatInputPreview(List<String> values, {int maxItems = 1000}) {
    return '[${values.join(', ')}]';
  }

  Widget _buildRunButton() {
    final canRun = _selectedFramework != null && _selectedAlgorithm != null && _selectedInput != null;
    
    return Column(
      children: [
        if (canRun) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSummaryRow('Framework', _getFrameworkDisplayName(_selectedFramework!)),
                const SizedBox(height: 10),
                _buildSummaryRow('Circuit', _selectedAlgorithm!),
                const SizedBox(height: 10),
                _buildSummaryRow('Input', _selectedInput!),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: canRun ? _runBenchmark : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canRun ? AppTheme.primary : AppTheme.border,
              foregroundColor: canRun ? Colors.white : AppTheme.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: canRun ? 4 : 0,
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
                      Text(
                        'Generating Proof...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        canRun ? Icons.play_arrow : Icons.info_outline,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        canRun 
                            ? 'Run Benchmark'
                            : 'Select Framework, Circuit & Input',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.text,
            ),
          ),
        ),
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

  String _getFrameworkDisplayName(String framework) {
    switch (framework) {
      case 'groth16':
        return 'Groth16';
      case 'barretenberg':
        return 'Barretenberg';
      case 'risc0':
        return 'RISC Zero';
      case 'cairo':
        return 'Cairo-M';
      case 'imp1':
        return 'IMP1';
      case 'provekit':
        return 'ProveKit';
      default:
        return framework;
    }
  }

  List<String> _getAlgorithmsForFramework(String framework) {
    switch (framework) {
      case 'groth16':
        return ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'RescuePrime'];
      case 'barretenberg':
        return ['SHA256', 'Keccak256', 'Poseidon', 'MiMC', 'Blake2', 'Blake3', 'RescuePrime', 'Anemoi'];
      case 'risc0':
        return ['Factor'];
      case 'cairo':
        return ['SHA256'];
      case 'imp1':
        return ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'MiMC256', 'Pedersen', 'Poseidon', 'RescuePrime'];
      case 'provekit':
        return ['Anemoi', 'MiMC', 'Poseidon', 'RescuePrime'];
      default:
        return [];
    }
  }

  void _updateAvailableInputs() {
    if (_selectedAlgorithm == null) {
      _availableInputs = [];
      _selectedInput = null;
      return;
    }

    // Bytes circuits: SHA256, Keccak256, Blake2s256, Blake3, Pedersen
    // Field circuits: MiMC256, Poseidon, RescuePrime
    final bytesAlgorithms = ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'Pedersen', 'Blake2'];
    
    if (bytesAlgorithms.contains(_selectedAlgorithm)) {
      if (_selectedFramework == 'groth16' || _selectedFramework == 'imp1') {
        final allowed = ['Input 16', 'Input 32', 'Input 64', 'Input 128'];
        _availableInputs = _bytesInputs.where((input) => allowed.contains(input.name)).toList();
      } else {
        _availableInputs = _bytesInputs;
      }
    } else {
      // Select field inputs based on framework
      if (_selectedFramework == 'barretenberg') {
        _availableInputs = _fieldInputsNoir;
      } else if (_selectedFramework == 'groth16') {
        _availableInputs = _fieldInputsCircom;
      } else if (_selectedFramework == 'provekit') {
        _availableInputs = _fieldInputsNoir;
      } else {
        // For other frameworks, use Groth16 inputs as default
        _availableInputs = _fieldInputsCircom;
      }
    }

    if (_availableInputs.isNotEmpty) {
      _selectedInput = _availableInputs.first.name;
    } else {
      _selectedInput = null;
    }
  }

  void _runBenchmark() async {
    if (_selectedFramework == null || _selectedAlgorithm == null || _selectedInput == null) return;

    // Immediately show loading state
    setState(() {
      _isLoading = true;
    });

    // Force UI to update by yielding to the event loop
    await Future.delayed(Duration.zero);

    if (!mounted) return;

    // Navigate immediately without waiting
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProofResultPage(
          framework: _selectedFramework!,
          algorithm: _selectedAlgorithm!,
          selectedInputName: _selectedInput!,
          selectedInputData: _availableInputs.firstWhere((input) => input.name == _selectedInput!),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}

// Smooth Loading Widget with Pulsing Effect
class SmoothLoadingIndicator extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const SmoothLoadingIndicator({
    Key? key,
    this.size = 60,
    this.strokeWidth = 5,
    this.color = AppTheme.primary,
  }) : super(key: key);

  @override
  State<SmoothLoadingIndicator> createState() => _SmoothLoadingIndicatorState();
}

class _SmoothLoadingIndicatorState extends State<SmoothLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: RotationTransition(
            turns: _rotationController,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                backgroundColor: widget.color.withOpacity(0.1),
              ),
            ),
          ),
        );
      },
    );
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
      case 'groth16':
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
    final zkeyAssetPath = _getZkeyPath();
    print("DEBUG: Asset Path: $zkeyAssetPath");

    // Capture memory and battery BEFORE proof generation
    final memSnapshotBefore = await _getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using actual MoPro
    print("DEBUG: Calling generateGroth16Proof with asset path: $zkeyAssetPath");
    final proofResult = await plugin.generateGroth16Proof(
      zkeyAssetPath, 
            inputs, 
      ProofLib.arkworks
    );
    
    stopwatch.stop();
    
    // Capture memory and battery AFTER proof generation
    final memSnapshotAfter = await _getMemorySnapshot();
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
    final (circuitPath, srsPath, onChain, vk, targetInputSize) = await _getNoirSettings();
    final List<String> noirInputs = _inputDataToNoirInput(inputData, targetInputSize);
    
    // Capture memory and battery BEFORE proof generation
    final memSnapshotBefore = await _getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();
    
    // Generate proof using actual MoPro with selected inputs
    final proof = await plugin.generateBarretenbergProof(
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
    final memSnapshotAfter = await _getMemorySnapshot();
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
    final memSnapshotBefore = await _getMemorySnapshot();
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
    final memSnapshotAfter = await _getMemorySnapshot();
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
    final circuitName = _getImp1CircuitName();
    
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


  String _getZkeyPath() {
    // Construct path dynamically based on algorithm and input size
    // naming convention: assets/groth16/zkey/{algorithm}_{suffix}.zkey
    
    // 1. Get algorithm name prefix
    String algoPrefix = widget.algorithm.toLowerCase();
    switch (widget.algorithm) {
      case 'RescuePrime':
        algoPrefix = 'rescue-prime';
        break;
      case 'Blake2s256':
        algoPrefix = 'blake2s256';
        break;
      // Other names match lowercase (sha256, keccak256, poseidon, mimc256, pedersen, blake3)
    }

    // 2. Get suffix from input name (e.g. "Input 16" -> "16", "Input 32f" -> "32f")
    // The input name format is strictly "Input {suffix}" as defined in MainSelectionPage
    final suffix = widget.selectedInputName.split(' ').last;
    
    return "assets/groth16/zkey/${algoPrefix}_${suffix}.zkey";
  }

  bool _isNoirBytesAlgorithm(String algorithm) {
    return ['SHA256', 'Keccak256', 'Blake2', 'Blake3', 'Pedersen']
        .contains(algorithm);
  }

  bool _isNoirFieldAlgorithm(String algorithm) {
    return ['Poseidon', 'MiMC', 'RescuePrime', 'Anemoi'].contains(algorithm);
  }

  int _parseSelectedInputSize() {
    final suffix = widget.selectedInputName.split(' ').last;
    final normalized = suffix.replaceAll('f', '');
    return int.tryParse(normalized) ?? 0;
  }

  int _mapNoirByteSize(int size) {
    // Map to nearest available circuit size
    if (size <= 16) return 16;
    if (size <= 32) return 32;
    if (size <= 64) return 64;
    if (size <= 128) return 128;
    if (size <= 256) return 256;
    if (size <= 512) return 512;
    return 1028;
  }

  int _mapNoirFieldSize(int size) {
    // Map to nearest available circuit size
    if (size <= 1) return 1;
    if (size <= 2) return 2;
    if (size <= 3) return 3;
    if (size <= 5) return 5;
    if (size <= 9) return 9;
    if (size <= 17) return 17;
    return 34;
  }

  String _normalizeNoirAlgorithmKey(String algorithm) {
    switch (algorithm.toLowerCase()) {
      case 'rescueprime':
      case 'rescue_prime':
        return 'rescue_prime';
      default:
        return algorithm.toLowerCase();
    }
  }

  Future<(String, String, bool, Uint8List, int)> _getNoirSettings() async {
    final moproFlutterPlugin = MoproFlutter();
    const bool lowMemoryMode = false;

    final algorithm = widget.algorithm;
    final algorithmKey = _normalizeNoirAlgorithmKey(algorithm);
    final rawInputSize = _parseSelectedInputSize();

    String assetPath;
    String srsPath;
    bool onChain;
    String? vkAssetPath;
    int targetInputSize;

    if (_isNoirBytesAlgorithm(algorithm)) {
      targetInputSize = _mapNoirByteSize(rawInputSize);
      if (algorithm == 'Pedersen') {
        assetPath = 'assets/pedersen.json';
        srsPath = 'assets/pedersen.srs';
        onChain = true;
        vkAssetPath = 'assets/pedersen.vk';
      } else {
        final baseName = '${algorithmKey}_bytes_$targetInputSize';
        assetPath = 'assets/barretenberg/$baseName.json';
        srsPath = 'assets/barretenberg/$baseName.srs';
        onChain = true;
      }
    } else if (_isNoirFieldAlgorithm(algorithm)) {
      targetInputSize = _mapNoirFieldSize(rawInputSize);
      final baseName = '${algorithmKey}_field_$targetInputSize';
      assetPath = 'assets/barretenberg/$baseName.json';
      srsPath = 'assets/barretenberg/$baseName.srs';
      onChain = algorithm != 'Poseidon';
    } else {
      targetInputSize = _mapNoirByteSize(rawInputSize);
      assetPath = 'assets/sha256.json';
      srsPath = 'assets/sha256.srs';
      onChain = true;
      vkAssetPath = 'assets/sha256.vk';
    }

    final cacheKey = '$assetPath|$srsPath|$onChain';
    final cachedKey = _noirVerificationKeys[cacheKey];
    if (cachedKey != null) {
      return (assetPath, srsPath, onChain, cachedKey, targetInputSize);
    }

    Uint8List? verificationKey;
    if (vkAssetPath != null) {
      try {
        final vkAsset = await rootBundle.load(vkAssetPath);
        verificationKey = vkAsset.buffer.asUint8List();
      } catch (e) {
        // Fall back to generating the verification key
      }
    }

    verificationKey ??= await moproFlutterPlugin.getBarretenbergVerificationKey(
      assetPath,
      srsPath,
      onChain,
      lowMemoryMode,
    );

    _noirVerificationKeys[cacheKey] = verificationKey;

    return (assetPath, srsPath, onChain, verificationKey, targetInputSize);
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

  List<String> _inputDataToNoirInput(List<String> inputData, int targetSize) {
    // Barretenberg circuits expect a fixed input size; pad or truncate to match
    final paddedData = List<String>.from(inputData);
    while (paddedData.length < targetSize) {
      paddedData.add('0');
    }
    return paddedData.take(targetSize).toList();
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
      case 'groth16':
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
    
    final zkeyAssetPath = _getZkeyPath();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final result = await plugin.verifyGroth16Proof(zkeyAssetPath, _circomProofResult!, ProofLib.arkworks);
    
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
    
    final (circuitPath, srsPath, onChain, vk, _) = await _getNoirSettings();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    final result = await plugin.verifyBarretenbergProof(circuitPath, _noirProofResult!, onChain, vk, false);
    
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
    
    final circuitName = _getImp1CircuitName();
    
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


  String _getImp1CircuitName() {
    // Construct path dynamically based on algorithm and input size
    // naming convention: {algorithm}_{suffix}
    
    // 1. Get algorithm name prefix
    String algoPrefix = widget.algorithm.toLowerCase();
    switch (widget.algorithm) {
      case 'RescuePrime':
        algoPrefix = 'rescue-prime';
        break;
      case 'Blake2s256':
        algoPrefix = 'blake2s256';
        break;
      // Other names match lowercase (sha256, keccak256, poseidon, mimc256, pedersen, blake3)
    }

    // 2. Get suffix from input name (e.g. "Input 16" -> "16", "Input 32f" -> "32f")
    final suffix = widget.selectedInputName.split(' ').last;
    
    return "${algoPrefix}_${suffix}";
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
        final deviceName = _mapIOSDeviceName(iosInfo.utsname.machine);
        deviceData = {
          'platform': 'iOS',
          'device': deviceName, 
          'manufacturer': 'Apple',
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'osVersion': iosInfo.systemVersion, // Alias for generic display
          'androidVersion': iosInfo.systemVersion, // Fallback for dashboard compatibility
          'name': iosInfo.name,
          'identifierForVendor': iosInfo.identifierForVendor,
          'deviceId': iosInfo.identifierForVendor, // Alias for generic ID
          'androidId': iosInfo.identifierForVendor, // Fallback for dashboard compatibility
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
      final memSnapshot = await _getMemorySnapshot();
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
        
        final memSnapshot = await _getMemorySnapshot();
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
    // Load the dedicated input file for Cairo
    // This ensures we match the exact format expected by the cairo-m prover (Vec<u32> + len)
    final inputsJson = await rootBundle.loadString('assets/cairo_input.json');
    
    // Capture memory and battery BEFORE proof generation
    _freeMemoryBeforeProof = SysInfo.getFreePhysicalMemory();
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;

    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Start memory monitoring in background
    _startMemoryMonitoring();

    final proofResult = await plugin.generateCairoProof(
      "assets/cairo_sha256.json",
      inputsJson
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

  // Helper to safely get current memory snapshot
  Future<({int free, int total})> _getMemorySnapshot() async {
    if (Platform.isAndroid) {
      try {
        return (
          free: SysInfo.getFreePhysicalMemory(),
          total: SysInfo.getTotalPhysicalMemory()
        );
      } catch (e) {
        print("Error getting memory info: $e");
      }
    } else if (Platform.isIOS) {
      try {
        final memoryInfo = await MoproFlutter().getIOSMemoryUsage();
        final used = memoryInfo['used'] ?? 0;
        final total = memoryInfo['total'] ?? 0;
        // Map iOS "App Used" to "Free" for compatibility with existing logic
        // Logic: Used = Total - Free  =>  Free = Total - Used
        return (free: total - used, total: total);
      } catch (e) {
        print("Error getting iOS memory info: $e");
      }
    }
    return (free: 0, total: 0);
  }

  String _mapIOSDeviceName(String machineId) {
    switch (machineId) {
      case 'iPhone14,5': return 'iPhone 13';
      case 'iPhone14,4': return 'iPhone 13 Mini';
      case 'iPhone14,2': return 'iPhone 13 Pro';
      case 'iPhone14,3': return 'iPhone 13 Pro Max';
      case 'iPhone14,7': return 'iPhone 14';
      case 'iPhone14,8': return 'iPhone 14 Plus';
      case 'iPhone15,2': return 'iPhone 14 Pro';
      case 'iPhone15,3': return 'iPhone 14 Pro Max';
      case 'iPhone15,4': return 'iPhone 15';
      case 'iPhone15,5': return 'iPhone 15 Plus';
      case 'iPhone16,1': return 'iPhone 15 Pro';
      case 'iPhone16,2': return 'iPhone 15 Pro Max';
      default: return machineId;
    }
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
    final circuitName = _getProveKitCircuitName();
    final pkpPath = 'assets/provekit/$circuitName.pkp';
    
    // Prepare input as TOML
    final inputValues = _getInputDataForAlgorithm();
    final inputToml = 'input = [${inputValues.map((v) => '"$v"').join(', ')}]\n';

    final memSnapshotBefore = await _getMemorySnapshot();
    _freeMemoryBeforeProof = memSnapshotBefore.free;
    final battery = Battery();
    _batteryBeforeProof = await battery.batteryLevel;
    
    final stopwatch = Stopwatch()..start();
    _startMemoryMonitoring();
    
    final proofResult = await plugin.generateProveKitProof(pkpPath, inputToml);
    
    stopwatch.stop();
    final memSnapshotAfter = await _getMemorySnapshot();
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
    final circuitName = _getProveKitCircuitName();
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

  String _getProveKitCircuitName() {
    String algoPrefix = widget.algorithm.toLowerCase();
    if (widget.algorithm == 'RescuePrime') {
      algoPrefix = 'rescue_prime';
    }
    final suffix = widget.selectedInputName.split(' ').last;
    if (_isNoirBytesAlgorithm(widget.algorithm) || widget.algorithm == 'SHA256') {
      return "${algoPrefix}_bytes_${suffix}";
    } else {
      return "${algoPrefix}_field_${suffix.replaceAll('f', '')}";
    }
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
