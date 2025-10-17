import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

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
  // Proofs & VKs per Noir circuit
  Uint8List? _mimcProofResult;
  Uint8List? _keccakProofResult;
  Uint8List? _poseidonProofResult;
  Uint8List? _pedersenProofResult;

  Uint8List? _mimcVerificationKey;
  Uint8List? _keccakVerificationKey;
  Uint8List? _poseidonVerificationKey;
  Uint8List? _pedersenVerificationKey;

  bool? _circomValid;
  bool? _halo2Valid;
  bool? _mimcValid;
  bool? _keccakValid;
  bool? _poseidonValid;
  bool? _pedersenValid;
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
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // MiMC
              OutlinedButton(
                onPressed: () async {
                  if (isProving) return;
                  setState(() {
                    _error = null;
                    isProving = true;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    final List<String> hardcodedInputs = [
                      "40","202","21","44","148","225","219","127",
                      "125","137","45","39","181","182","116","221",
                      "65","64","40","99","92","60","3","33",
                      "40","159","154","251","14","238","144","106"
                    ];
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    if (_mimcVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/mimc.vk');
                        _mimcVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _mimcVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                          "assets/mimc.json",
                          "assets/mimc.srs",
                          onChain,
                          lowMemoryMode,
                        );
                      }
                    }
                    final proof = await _moproFlutterPlugin.generateNoirProof(
                      "assets/mimc.json",
                      "assets/mimc.srs",
                      hardcodedInputs,
                      onChain,
                      _mimcVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _mimcProofResult = proof;
                      _mimcValid = null;
                      _keccakProofResult = null;
                      _poseidonProofResult = null;
                      _keccakValid = null;
                      _poseidonValid = null;
                    });
                  } on Exception catch (e) {
                    setState(() { _error = e; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Generate MiMC Proof'),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (isProving || _mimcProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/mimc.json",
                      _mimcProofResult!,
                      onChain,
                      _mimcVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _mimcValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _mimcValid = false; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Verify MiMC Proof'),
              ),

              // Keccak
              OutlinedButton(
                onPressed: () async {
                  if (isProving) return;
                  setState(() { _error = null; isProving = true; });
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    final List<String> hardcodedInputs = [
                      "40","202","21","44","148","225","219","127",
                      "125","137","45","39","181","182","116","221",
                      "65","64","40","99","92","60","3","33",
                      "40","159","154","251","14","238","144","106"
                    ];
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    if (_keccakVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/keccak.vk');
                        _keccakVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _keccakVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                          "assets/keccak256.json",
                          "assets/keccak256.srs",
                          onChain,
                          lowMemoryMode,
                        );
                      }
                    }
                    final proof = await _moproFlutterPlugin.generateNoirProof(
                      "assets/keccak256.json",
                      "assets/keccak256.srs",
                      hardcodedInputs,
                      onChain,
                      _keccakVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _keccakProofResult = proof;
                      _keccakValid = null;
                      _mimcProofResult = null;
                      _poseidonProofResult = null;
                      _mimcValid = null;
                      _poseidonValid = null;
                    });
                  } on Exception catch (e) {
                    setState(() { _error = e; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Generate Keccak Proof'),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (isProving || _keccakProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/keccak256.json",
                      _keccakProofResult!,
                      onChain,
                      _keccakVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _keccakValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _keccakValid = false; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Verify Keccak Proof'),
              ),

              // Poseidon
              OutlinedButton(
                onPressed: () async {
                  if (isProving) return;
                  setState(() { _error = null; isProving = true; });
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    final List<String> hardcodedInputs = [
                      "40","202","21","44","148","225","219","127",
                      "125","137","45","39","181","182","116","221",
                      "65","64","40","99","92","60","3","33",
                      "40","159","154","251","14","238","144","106"
                    ];
                    const bool onChain = false; // Poseidon usually not on-chain
                    const bool lowMemoryMode = false;
                    if (_poseidonVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/poseidon.vk');
                        _poseidonVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _poseidonVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                          "assets/poseidon.json",
                          "assets/poseidon.srs",
                          onChain,
                          lowMemoryMode,
                        );
                      }
                    }
                    final proof = await _moproFlutterPlugin.generateNoirProof(
                      "assets/poseidon.json",
                      "assets/poseidon.srs",
                      hardcodedInputs,
                      onChain,
                      _poseidonVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _poseidonProofResult = proof;
                      _poseidonValid = null;
                      _mimcProofResult = null;
                      _keccakProofResult = null;
                      _mimcValid = null;
                      _keccakValid = null;
                    });
                  } on Exception catch (e) {
                    setState(() { _error = e; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Generate Poseidon Proof'),
              ),
              // Pedersen
              OutlinedButton(
                onPressed: () async {
                  if (isProving) return;
                  setState(() { _error = null; isProving = true; });
                  FocusManager.instance.primaryFocus?.unfocus();
                  try {
                    final List<String> hardcodedInputs = [
                      "40","202","21","44","148","225","219","127",
                      "125","137","45","39","181","182","116","221",
                      "65","64","40","99","92","60","3","33",
                      "40","159","154","251","14","238","144","106"
                    ];
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    if (_pedersenVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/pedersen.vk');
                        _pedersenVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _pedersenVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                          "assets/pedersen.json",
                          "assets/pedersen.srs",
                          onChain,
                          lowMemoryMode,
                        );
                      }
                    }
                    final proof = await _moproFlutterPlugin.generateNoirProof(
                      "assets/pedersen.json",
                      "assets/pedersen.srs",
                      hardcodedInputs,
                      onChain,
                      _pedersenVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _pedersenProofResult = proof;
                      _pedersenValid = null;
                      _mimcProofResult = null;
                      _keccakProofResult = null;
                      _poseidonProofResult = null;
                      _mimcValid = null;
                      _keccakValid = null;
                      _poseidonValid = null;
                    });
                  } on Exception catch (e) {
                    setState(() { _error = e; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Generate Pedersen Proof'),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (isProving || _pedersenProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/pedersen.json",
                      _pedersenProofResult!,
                      onChain,
                      _pedersenVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _pedersenValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _pedersenValid = false; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Verify Pedersen Proof'),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (isProving || _poseidonProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = false;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/poseidon.json",
                      _poseidonProofResult!,
                      onChain,
                      _poseidonVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _poseidonValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _poseidonValid = false; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Verify Poseidon Proof'),
              ),
            ],
          ),
          Column(
            children: [
              if (_mimcProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MiMC proof is valid: ${_mimcValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MiMC proof: ${_mimcProofResult}'),
                ),
              ],
              if (_keccakProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Keccak proof is valid: ${_keccakValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Keccak proof: ${_keccakProofResult}'),
                ),
              ],
              if (_poseidonProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Poseidon proof is valid: ${_poseidonValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Poseidon proof: ${_poseidonProofResult}'),
                ),
              ],
              if (_pedersenProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pedersen proof is valid: ${_pedersenValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pedersen proof: ${_pedersenProofResult}'),
                ),
              ],
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
