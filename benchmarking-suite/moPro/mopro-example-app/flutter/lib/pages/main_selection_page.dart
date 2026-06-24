import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:Deimos/models/benchmark_item.dart';
import 'package:Deimos/pages/batch_execution_page.dart';
import 'package:Deimos/pages/proof_result_page.dart';
import 'package:Deimos/theme/app_theme.dart';
import 'package:Deimos/utils/circuit_registry.dart';
import 'package:Deimos/utils/benchmark_references.dart';
import 'package:Deimos/widgets/instrument_widgets.dart';

class MainSelectionPage extends StatefulWidget {
  const MainSelectionPage({super.key});

  @override
  State<MainSelectionPage> createState() => _MainSelectionPageState();
}

class _MainSelectionPageState extends State<MainSelectionPage> {
  String? _selectedFramework;
  String? _selectedAlgorithm;
  String? _selectedInput;
  bool _isLoading = false;
  bool _isLoadingInputs = true;
  
  List<InputData> _availableInputs = [];
  final List<InputData> _bytesInputs = [];
  final List<InputData> _fieldInputsNoir = [];
  final List<InputData> _fieldInputsCircom = [];
  final List<InputData> _fieldInputsCairo = [];
  final List<InputData> _u32InputsCairo = [];

  @override
  void initState() {
    super.initState();
    _loadInputs();
  }

  Future<void> _loadInputs() async {
    try {
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
          debugPrint('Error loading bytes input $size: $e');
        }
      }

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
          debugPrint('Error loading field input noir $size: $e');
        }
      }

      final fieldSizesCircom = ['1f', '2f', '3f', '5f', '9f', '17f', '34f'];
      for (var size in fieldSizesCircom) {
        try {
          final inputData = await _loadInputFromJson(
            'inputs/field_elements/input$size.json',
            name: 'Input $size',
            description: '$size field elements input',
          );
          _fieldInputsCircom.add(inputData);
        } catch (e) {
          debugPrint('Error loading field input circom $size: $e');
        }
      }

      final m31Sizes = ['5m', '9m', '17m', '34m', '67m', '133m', '265m'];
      for (var size in m31Sizes) {
        try {
          final inputData = await _loadInputFromJson(
            'inputs/m31_field/input$size.json',
            name: 'Input $size',
            description: '$size M31 field elements',
          );
          _fieldInputsCairo.add(inputData);
        } catch (e) {
          debugPrint('Error loading m31 input $size: $e');
        }
      }

      final u32Sizes = ['4u', '8u', '16u', '32u', '64u', '128u', '256u'];
      for (var size in u32Sizes) {
        try {
          final inputData = await _loadInputFromJson(
            'inputs/u32/input$size.json',
            name: 'Input $size',
            description: '$size U32 integers',
          );
          _u32InputsCairo.add(inputData);
        } catch (e) {
          debugPrint('Error loading u32 input $size: $e');
        }
      }

      setState(() {
        _isLoadingInputs = false;
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
      
      final String finalName = name ?? (jsonData['name'] as String? ?? 'Unknown');
      final String finalDescription = description ?? (jsonData['description'] as String? ?? '');
      final List<dynamic> inArray = jsonData['in'] as List<dynamic>;
      
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

  void _updateAvailableInputs() {
    if (_selectedAlgorithm == null) {
      _availableInputs = [];
      _selectedInput = null;
      return;
    }

    final bytesAlgorithms = ['SHA256', 'Keccak256', 'Blake2s256', 'Blake3', 'Pedersen', 'Blake2'];
    
    if (bytesAlgorithms.contains(_selectedAlgorithm)) {
      if (_selectedFramework == 'arkworks' || _selectedFramework == 'rapidsnark' || _selectedFramework == 'imp1') {
        final allowed = ['Input 16', 'Input 32', 'Input 64', 'Input 128'];
        _availableInputs = _bytesInputs.where((input) => allowed.contains(input.name)).toList();
      } else if (_selectedFramework == 'cairo') {
        _availableInputs = _u32InputsCairo;
      } else {
        _availableInputs = _bytesInputs;
      }
    } else {
      if (_selectedFramework == 'barretenberg') {
        _availableInputs = _fieldInputsNoir;
      } else if (_selectedFramework == 'arkworks' || _selectedFramework == 'rapidsnark') {
        _availableInputs = _fieldInputsCircom;
      } else if (_selectedFramework == 'provekit') {
        _availableInputs = _fieldInputsNoir;
      } else if (_selectedFramework == 'cairo') {
        _availableInputs = _fieldInputsCairo;
      } else {
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

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration.zero);
    if (!mounted) return;

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

  void _showPicker(String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _buildBottomSheet(type);
      },
    );
  }

  Widget _buildBottomSheet(String type) {
    List<dynamic> items = [];
    String titleText = '';
    
    if (type == 'fw') {
      titleText = 'SELECT FRAMEWORK';
      items = BenchmarkReferences.frameworks.map((f) => {
        'id': f.id,
        'name': f.name,
        'type': f.type,
        'lang': f.lang,
      }).toList();
    } else if (type == 'circuit') {
      titleText = 'SELECT CIRCUIT';
      final algos = CircuitRegistry.getAlgorithmsForFramework(_selectedFramework!);
      items = algos.map((a) => {
        'id': a,
        'name': a,
        'family': BenchmarkReferences.getCircuitFamily(a),
      }).toList();
    } else if (type == 'input') {
      titleText = 'SELECT INPUT';
      items = _availableInputs.map((i) => {'id': i.name, 'name': i.name, 'family': 'Vector'}).toList();
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SIMono(titleText, fontSize: 11, letterSpacing: 2, color: AppTheme.textDim),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppTheme.text, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final it = items[index];
                bool active = false;
                if (type == 'fw') active = _selectedFramework == it['id'];
                if (type == 'circuit') active = _selectedAlgorithm == it['id'];
                if (type == 'input') active = _selectedInput == it['id'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (type == 'fw') {
                        _selectedFramework = it['id'];
                        _selectedAlgorithm = null;
                        _updateAvailableInputs();
                      } else if (type == 'circuit') {
                        _selectedAlgorithm = it['id'];
                        _updateAvailableInputs();
                      } else if (type == 'input') {
                        _selectedInput = it['id'];
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: active ? AppTheme.surface2 : Colors.transparent,
                      border: const Border(bottom: BorderSide(color: AppTheme.border)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: SIMono(
                            (index + 1).toString().padLeft(2, '0'),
                            color: AppTheme.textDim,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SIMono(it['name'], fontSize: 15, fontWeight: FontWeight.w500),
                              if (it['lang'] != null)
                                SIMono('${it['type']} · ${it['lang']}', fontSize: 12, color: AppTheme.textDim),
                              if (it['family'] != null && it['lang'] == null)
                                SIMono(it['family'], fontSize: 12, color: AppTheme.textDim),
                            ],
                          ),
                        ),
                        if (active)
                          Container(width: 8, height: 8, color: AppTheme.accent),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String step, String label, String? value, String? sub, bool disabled, VoidCallback onClick) {
    return GestureDetector(
      onTap: disabled ? null : onClick,
      child: Opacity(
        opacity: disabled ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 22,
                child: SIMono(step, color: AppTheme.textDim),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SIMono(label.toUpperCase(), fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                    const SizedBox(height: 2),
                    SIMono(
                      value ?? '—— ——',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: value != null ? AppTheme.text : AppTheme.textMuted,
                    ),
                    const SizedBox(height: 2),
                    SIMono(sub ?? '', fontSize: 12, color: AppTheme.textDim),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: AppTheme.textDim),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingInputs) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.text)),
      );
    }

    final fwName = _selectedFramework != null ? CircuitRegistry.getFrameworkDisplayName(_selectedFramework!) : null;
    final fwMeta = _selectedFramework != null ? BenchmarkReferences.getMeta(_selectedFramework!) : null;
    final circuitFamily = _selectedAlgorithm != null ? BenchmarkReferences.getCircuitFamily(_selectedAlgorithm!) : null;
    final canRun = _selectedFramework != null && _selectedAlgorithm != null && _selectedInput != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        color: AppTheme.text,
                        alignment: Alignment.center,
                        child: Container(width: 8, height: 8, color: AppTheme.accent),
                      ),
                      const SizedBox(width: 10),
                      const SIMono('DEIMOS', fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.w500),
                    ],
                  ),
                  Row(
                    children: [
                      _buildTopButton('HIST', () {}),
                      const SizedBox(width: 4),
                      _buildTopButton('CMP', () {}),
                      const SizedBox(width: 4),
                      _buildTopIconButton(Icons.memory, () {}),
                    ],
                  ),
                ],
              ),
            ),
            
            // Ticker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  const SIMono('● SELECT FRAMEWORK', fontSize: 10, letterSpacing: 1.5, color: AppTheme.accent),
                  const SizedBox(width: 16),
                  const SIMono('CIRCUIT', fontSize: 10, color: AppTheme.textDim),
                  const SizedBox(width: 16),
                  const SIMono('INPUT', fontSize: 10, color: AppTheme.textDim),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SIMono('── New Benchmark ──', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                  const SizedBox(height: 4),
                  const SIMono(
                    'Configure\nrun parameters.',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1,
                  ),
                  const SizedBox(height: 24),

                  _buildConfigRow(
                    '01',
                    'Framework',
                    fwName,
                    fwMeta != null ? '${fwMeta.type} · ${fwMeta.lang}' : 'Select backend',
                    false,
                    () => _showPicker('fw'),
                  ),
                  _buildConfigRow(
                    '02',
                    'Circuit',
                    _selectedAlgorithm,
                    circuitFamily != null ? circuitFamily : (_selectedFramework != null ? 'Select algorithm' : 'Select framework first'),
                    _selectedFramework == null,
                    () => _showPicker('circuit'),
                  ),
                  _buildConfigRow(
                    '03',
                    'Input',
                    _selectedInput,
                    _selectedInput != null ? 'Field vector' : (_selectedAlgorithm != null ? 'Select vector' : 'Select circuit first'),
                    _selectedAlgorithm == null,
                    () => _showPicker('input'),
                  ),

                  // Summary
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SIMono('RUN MANIFEST', fontSize: 10, letterSpacing: 2, color: AppTheme.textDim),
                        const SizedBox(height: 10),
                        SIKV(k: 'Framework', v: fwName ?? '—'),
                        SIKV(k: 'Circuit', v: _selectedAlgorithm ?? '—'),
                        SIKV(k: 'Input', v: _selectedInput ?? '—'),
                        const SIKV(k: 'Target', v: 'Local Device'),
                        const SIKV(k: 'Trials', v: '1'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Actions
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: canRun ? _runBenchmark : null,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: canRun ? AppTheme.text : AppTheme.surface2,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isLoading)
                              const SizedBox(
                                width: 14, height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.background),
                              )
                            else
                              SIMono(
                                '▸ EXECUTE',
                                fontSize: 12,
                                letterSpacing: 2,
                                color: canRun ? AppTheme.background : AppTheme.textMuted,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BatchExecutionPage(allInputs: [
                            ..._bytesInputs,
                            ..._fieldInputsNoir,
                            ..._fieldInputsCircom,
                            ..._fieldInputsCairo,
                            ..._u32InputsCairo,
                          ]),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.border),
                      ),
                      alignment: Alignment.center,
                      child: const SIMono(
                        'RUN ALL',
                        fontSize: 12,
                        letterSpacing: 2,
                        color: AppTheme.text,
                      ),
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

  Widget _buildTopButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
        ),
        child: SIMono(text, fontSize: 10, letterSpacing: 1.5, color: AppTheme.text),
      ),
    );
  }

  Widget _buildTopIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, size: 16, color: AppTheme.text),
      ),
    );
  }
}
