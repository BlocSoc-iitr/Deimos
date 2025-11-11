import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_types.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  CircomProofResult? _circomProofResult;
  Halo2ProofResult? _halo2ProofResult;
  Uint8List? _noirProofResult;
  Uint8List? _noirVerificationKey;
  Risc0ProofOutput? _risc0ProofResult;
  Risc0VerifyOutput? _risc0VerifyResult;
  bool? _circomValid;
  bool? _halo2Valid;
  bool? _noirValid;
  final _moproFlutterPlugin = MoproFlutter();
  bool isProving = false;
  bool isVerifying = false;
  Exception? _error;
  late TabController _tabController;

  // Controllers to handle user input (commented out for hardcoded Keccak)
  // final TextEditingController _controllerA = TextEditingController();
  // final TextEditingController _controllerB = TextEditingController();
  final TextEditingController _controllerOut = TextEditingController();
  final TextEditingController _controllerNoirA = TextEditingController();
  final TextEditingController _controllerNoirB = TextEditingController();
  final TextEditingController _controllerRisc0Input = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _controllerA.text = "5";  // Commented out for hardcoded Keccak
    // _controllerB.text = "3";  // Commented out for hardcoded Keccak
    _controllerOut.text = "55";
    _controllerNoirA.text = "5";
    _controllerNoirB.text = "3";
    _controllerRisc0Input.text = "42";
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCircomTab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isProving) const CircularProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error.toString()),
            ),
          // Commented out input fields for hardcoded Keccak testing
          /*
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerA,
              decoration: const InputDecoration(
                labelText: "Public input `a`",
                hintText: "For example, 5",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerB,
              decoration: const InputDecoration(
                labelText: "Private input `b`",
                hintText: "For example, 3",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          */
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Keccak256 Proof Generation\nUsing hardcoded input: "Hello World! This is a test msg."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      // Removed input validation since we're using hardcoded values
                      if (isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      CircomProofResult? proofResult;
                      try {
                        // Hardcoded Keccak input: "Hello World! This is a test msg." as byte array
                        var inputs = '''{
    "in": [
        "72",
        "101",
        "108",
        "108",
        "111",
        "32",
        "87",
        "111",
        "114",
        "108",
        "100",
        "33",
        "32",
        "84",
        "104",
        "105",
        "115",
        "32",
        "105",
        "115",
        "32",
        "97",
        "32",
        "116",
        "101",
        "115",
        "116",
        "32",
        "109",
        "115",
        "103",
        "46"
    ]
}''';
                        proofResult =
                            await _moproFlutterPlugin.generateCircomProof(
                                "assets/circom.zkey", inputs, ProofLib.arkworks);  // Using Keccak zkey
                      } on Exception catch (e) {
                        print("Error: $e");
                        proofResult = null;
                        setState(() {
                          _error = e;
                        });
                      }

                      if (!mounted) return;

                      setState(() {
                        isProving = false;
                        _circomProofResult = proofResult;
                      });
                    },
                    child: const Text("Generate Proof")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      // Removed input validation since we're using hardcoded values
                      if (isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      bool? valid;
                      try {
                        var proofResult = _circomProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/circom.zkey", proofResult!, ProofLib.arkworks); // Using Keccak zkey
                      } on Exception catch (e) {
                        print("Error: $e");
                        valid = false;
                        setState(() {
                          _error = e;
                        });
                      } on TypeError catch (e) {
                        print("Error: $e");
                        valid = false;
                        setState(() {
                          _error = Exception(e.toString());
                        });
                      }

                      if (!mounted) return;

                      setState(() {
                        isProving = false;
                        _circomValid = valid;
                      });
                    },
                    child: const Text("Verify Proof")),
              ),
            ],
          ),
          if (_circomProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Proof is valid: ${_circomValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Proof inputs: ${_circomProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Proof: ${_circomProofResult?.proof ?? ""}'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHalo2Tab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isProving) const CircularProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error.toString()),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerOut,
              decoration: const InputDecoration(
                labelText: "Public input `out`",
                hintText: "For example, 55",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      if (_controllerOut.text.isEmpty || isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      Halo2ProofResult? halo2ProofResult;
                      try {
                        var inputs = {
                          "out": [(_controllerOut.text)]
                        };
                        halo2ProofResult =
                            await _moproFlutterPlugin.generateHalo2Proof(
                                "assets/plonk_fibonacci_srs.bin",
                                "assets/plonk_fibonacci_pk.bin",
                                inputs);
                      } on Exception catch (e) {
                        print("Error: $e");
                        halo2ProofResult = null;
                        setState(() {
                          _error = e;
                        });
                      }

                      if (!mounted) return;

                      setState(() {
                        isProving = false;
                        _halo2ProofResult = halo2ProofResult;
                      });
                    },
                    child: const Text("Generate Proof")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      if (_controllerOut.text.isEmpty || isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      bool? valid;
                      try {
                        var proofResult = _halo2ProofResult;
                        valid = await _moproFlutterPlugin.verifyHalo2Proof(
                            "assets/plonk_fibonacci_srs.bin",
                            "assets/plonk_fibonacci_vk.bin",
                            proofResult!.proof,
                            proofResult.inputs);
                      } on Exception catch (e) {
                        print("Error: $e");
                        valid = false;
                        setState(() {
                          _error = e;
                        });
                      } on TypeError catch (e) {
                        print("Error: $e");
                        valid = false;
                        setState(() {
                          _error = Exception(e.toString());
                        });
                      }

                      if (!mounted) return;

                      setState(() {
                        _halo2Valid = valid;
                        isProving = false;
                      });
                    },
                    child: const Text("Verify Proof")),
              ),
            ],
          ),
          if (_halo2ProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Proof is valid: ${_halo2Valid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Proof inputs: ${_halo2ProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Proof: ${_halo2ProofResult?.proof ?? ""}'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNoirTab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isProving) const CircularProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error.toString()),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerNoirA,
              decoration: const InputDecoration(
                labelText: "Public input `a`",
                hintText: "For example, 3",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerNoirB,
              decoration: const InputDecoration(
                labelText: "Public input `b`",
                hintText: "For example, 5",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      if (_controllerNoirA.text.isEmpty || _controllerNoirB.text.isEmpty || isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      Uint8List? noirProofResult;
                      try {
                        var inputs = [
                          _controllerNoirA.text,
                          _controllerNoirB.text
                        ];
                        
                        // Constants for Noir proof generation
                        const bool onChain = true;  // Use Keccak for Solidity compatibility
                        const bool lowMemoryMode = false;
                        
                        // Get or generate verification key if not already available
                        if (_noirVerificationKey == null) {
                          setState(() {
                            _error = null;
                          });
                          // Try to load existing VK from assets, or generate new one
                          try {
                            // First try to load existing VK from assets
                            final vkAsset = await rootBundle.load('assets/noir_multiplier2.vk');
                            _noirVerificationKey = vkAsset.buffer.asUint8List();
                          } catch (e) {
                            // If VK doesn't exist in assets, generate it
                            _noirVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                              "assets/noir_multiplier2.json",
                              "assets/noir_multiplier2.srs",
                              onChain,
                              lowMemoryMode
                            );
                          }
                        }
                        
                        noirProofResult =
                            await _moproFlutterPlugin.generateNoirProof(
                                "assets/noir_multiplier2.json",
                                "assets/noir_multiplier2.srs",
                                inputs,
                                onChain,
                                _noirVerificationKey!,
                                lowMemoryMode);
                      } on Exception catch (e) {
                        print("Error: $e");
                        noirProofResult = null;
                        setState(() {
                          _error = e;
                        });
                      }

                      if (!mounted) return;

                      setState(() {
                        isProving = false;
                        _noirProofResult = noirProofResult;
                      });
                    },
                    child: const Text("Generate Proof")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      if (_controllerNoirA.text.isEmpty || _controllerNoirB.text.isEmpty || isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      bool? valid;
                      try {
                        var proofResult = _noirProofResult;
                        var vk = _noirVerificationKey;
                        
                        if (vk == null) {
                          throw Exception("Verification key not available. Generate proof first.");
                        }
                        
                        // Constants for Noir proof verification
                        const bool onChain = true;  // Use Keccak for Solidity compatibility
                        const bool lowMemoryMode = false;
                        
                        valid = await _moproFlutterPlugin.verifyNoirProof(
                            "assets/noir_multiplier2.json",
                            proofResult!,
                            onChain,
                            vk,
                            lowMemoryMode);
                      } on Exception catch (e) {
                        print("Error: $e");
                        valid = false;
                        setState(() {
                          _error = e;
                        });
                      } on TypeError catch (e) {
                        print("Error: $e");
                        valid = false;
                        setState(() {
                          _error = Exception(e.toString());
                        });
                      }

                      if (!mounted) return;

                      setState(() {
                        _noirValid = valid;
                        isProving = false;
                      });
                    },
                    child: const Text("Verify Proof")),
              ),
            ],
          ),
          if (_noirProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Proof is valid: ${_noirValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Proof: ${_noirProofResult ?? ""}'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRisc0Tab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isProving || isVerifying) const CircularProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _error.toString(),
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controllerRisc0Input,
              decoration: const InputDecoration(
                labelText: "Input value (u32)",
                hintText: "For example, 42",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 160,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: (_controllerRisc0Input.text.isEmpty || isProving || isVerifying)
                      ? null
                      : () async {
                        HapticFeedback.lightImpact();

                        setState(() {
                          _error = null;
                          isProving = true;
                          _risc0VerifyResult = null;
                        });

                        FocusManager.instance.primaryFocus?.unfocus();
                        Risc0ProofOutput? risc0ProofResult;
                        try {
                          final inputValue = int.parse(_controllerRisc0Input.text);
                          if (inputValue < 0 || inputValue > 4294967295) {
                            throw Exception("Input must be a valid u32 (0 to 4294967295)");
                          }
                          risc0ProofResult = await _moproFlutterPlugin.generateRisc0Proof(inputValue);
                        } on Exception catch (e) {
                          print("Error: $e");
                          risc0ProofResult = null;
                          setState(() {
                            _error = e;
                          });
                        } on FormatException catch (e) {
                          print("Error: $e");
                          risc0ProofResult = null;
                          setState(() {
                            _error = Exception("Invalid input format. Please enter a valid number.");
                          });
                        }

                        if (!mounted) return;

                        setState(() {
                          isProving = false;
                          _risc0ProofResult = risc0ProofResult;
                        });
                      },
                    child: isProving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("Proving..."),
                          ],
                        )
                      : const Text("Generate Proof"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 160,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: (_risc0ProofResult != null && !isProving && !isVerifying)
                      ? () async {
                        HapticFeedback.lightImpact();

                        setState(() {
                          _error = null;
                          isVerifying = true;
                        });

                        FocusManager.instance.primaryFocus?.unfocus();
                        Risc0VerifyOutput? verifyResult;
                        try {
                          verifyResult = await _moproFlutterPlugin.verifyRisc0Proof(_risc0ProofResult!.receipt);
                        } on Exception catch (e) {
                          print("Error: $e");
                          verifyResult = null;
                          setState(() {
                            _error = e;
                          });
                        }

                        if (!mounted) return;

                        setState(() {
                          _risc0VerifyResult = verifyResult;
                          isVerifying = false;
                        });
                      }
                      : null,
                    child: isVerifying
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text("Verifying..."),
                          ],
                        )
                      : const Text("Verify Proof"),
                  ),
                ),
              ),
            ],
          ),
          if (_risc0ProofResult != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Proof Generated Successfully!'),
                  const SizedBox(height: 8),
                  Text('Receipt size: ${(_risc0ProofResult!.receipt.length / 1024).toStringAsFixed(1)} KB'),
                  if (_risc0VerifyResult != null) ...[
                    const SizedBox(height: 16),
                    Text('Verification: ${_risc0VerifyResult!.isValid ? "PASSED" : "FAILED"}'),
                    const SizedBox(height: 4),
                    Text('Output value: ${_risc0VerifyResult!.outputValue}'),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App With MoPro'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Circom'),
              Tab(text: 'Halo2'),
              Tab(text: 'Noir'),
              Tab(text: 'RISC Zero'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCircomTab(),
            _buildHalo2Tab(),
            _buildNoirTab(),
            _buildRisc0Tab(),
          ],
        ),
      ),
    );
  }
}
