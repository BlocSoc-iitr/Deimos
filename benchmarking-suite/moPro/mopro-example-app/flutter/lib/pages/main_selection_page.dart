import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:Deimos/models/benchmark_item.dart';
import 'package:Deimos/pages/batch_execution_page.dart';
import 'package:Deimos/pages/proof_result_page.dart';
import 'package:Deimos/theme/app_theme.dart';
import 'package:Deimos/utils/circuit_registry.dart';

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
              const SizedBox(height: 16),
              _buildBatchButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatchButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BatchExecutionPage(allInputs: [
                ..._bytesInputs,
                ..._fieldInputsNoir,
                ..._fieldInputsCircom,
              ]),
            ),
          );
        },
        icon: const Icon(Icons.auto_awesome, color: AppTheme.primary),
        label: const Text(
          'Prove & Verify All',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
      {'name': 'Arkworks', 'value': 'arkworks', 'icon': Icons.verified_user},
      {'name': 'Rapidsnark', 'value': 'rapidsnark', 'icon': Icons.bolt},
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
    final algorithms = isEnabled ? CircuitRegistry.getAlgorithmsForFramework(_selectedFramework!) : <String>[];
    
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
                _buildSummaryRow('Framework', CircuitRegistry.getFrameworkDisplayName(_selectedFramework!)),
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
      if (_selectedFramework == 'arkworks' || _selectedFramework == 'rapidsnark' || _selectedFramework == 'imp1') {
        final allowed = ['Input 16', 'Input 32', 'Input 64', 'Input 128'];
        _availableInputs = _bytesInputs.where((input) => allowed.contains(input.name)).toList();
      } else {
        _availableInputs = _bytesInputs;
      }
    } else {
      // Select field inputs based on framework
      if (_selectedFramework == 'barretenberg') {
        _availableInputs = _fieldInputsNoir;
      } else if (_selectedFramework == 'arkworks' || _selectedFramework == 'rapidsnark') {
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

