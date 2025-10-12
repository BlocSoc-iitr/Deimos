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
  bool? _circomValid;
  bool? _halo2Valid;
  bool? _noirValid;
  final _moproFlutterPlugin = MoproFlutter();
  bool isProving = false;
  Exception? _error;
  late TabController _tabController;

  // Controllers to handle user input
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  final TextEditingController _controllerOut = TextEditingController();
  final TextEditingController _controllerNoirA = TextEditingController();
  final TextEditingController _controllerNoirB = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerA.text = "5";
    _controllerB.text = "3";
    _controllerOut.text = "55";
    _controllerNoirA.text = "5";
    _controllerNoirB.text = "3";
    _tabController = TabController(length: 3, vsync: this);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
                      if (_controllerA.text.isEmpty ||
                          _controllerB.text.isEmpty ||
                          isProving) {
                        return;
                      }
                      setState(() {
                        _error = null;
                        isProving = true;
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                      CircomProofResult? proofResult;
                      try {
                        var inputs =
                            '{"a":["${_controllerA.text}"],"b":["${_controllerB.text}"]}';
                        proofResult =
                            await _moproFlutterPlugin.generateCircomProof(
                                "assets/multiplier2_final.zkey", inputs, ProofLib.arkworks);  // DO NOT change the proofLib if you don't build for rapidsnark
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
                      if (_controllerA.text.isEmpty ||
                          _controllerB.text.isEmpty ||
                          isProving) {
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
                            "assets/multiplier2_final.zkey", proofResult!, ProofLib.arkworks); // DO NOT change the proofLib if you don't build for rapidsnark
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
                        final List<String> hardcodedInputs = [
                          "40","202","21","44","148","225","219","127",
                          "125","137","45","39","181","182","116","221",
                          "65","64","40","99","92","60","3","33",
                          "40","159","154","251","14","238","144","106"
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
                            final vkAsset = await rootBundle.load('assets/sims.vk');
                            _noirVerificationKey = vkAsset.buffer.asUint8List();
                          } catch (e) {
                            // If VK doesn't exist in assets, generate it
                            _noirVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                              "assets/mimc.json",
                              "assets/mimc.srs",
                              onChain,
                              lowMemoryMode
                            );
                          }
                        }
                        print("VK length: ${_noirVerificationKey?.length ?? 'null'}");
                        noirProofResult =
                            await _moproFlutterPlugin.generateNoirProof(
                                "assets/mimc.json",
                                "assets/mimc.srs",
                                hardcodedInputs.map((e) => e.toString()).toList(),
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
                      print(noirProofResult); 
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
                            "assets/mimc.json",
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
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCircomTab(),
            _buildHalo2Tab(),
            _buildNoirTab(),
          ],
        ),
      ),
    );
  }
}
