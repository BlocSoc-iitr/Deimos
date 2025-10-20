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
  // Circom proofs
  CircomProofResult? _circomKeccakProofResult;
  CircomProofResult? _circomSha256ProofResult;
  bool? _circomKeccakValid;
  bool? _circomSha256Valid;
  
  // Halo2 proofs
  Halo2ProofResult? _halo2ProofResult;
  bool? _halo2Valid;
  
  // Noir proofs & VKs
  Uint8List? _noirMimcProofResult;
  Uint8List? _noirKeccakProofResult;
  Uint8List? _noirPoseidonProofResult;
  Uint8List? _noirPedersenProofResult;

  Uint8List? _noirMimcVerificationKey;
  Uint8List? _noirKeccakVerificationKey;
  Uint8List? _noirPoseidonVerificationKey;
  Uint8List? _noirPedersenVerificationKey;

  bool? _noirMimcValid;
  bool? _noirKeccakValid;
  bool? _noirPoseidonValid;
  bool? _noirPedersenValid;
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
          
          // Keccak256 Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Keccak256 Proof Generation\nUsing hardcoded input: "Hello World! This is a test msg."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
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
                                "assets/keccak.zkey", inputs, ProofLib.arkworks);  // Using Keccak zkey
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
                        _circomKeccakProofResult = proofResult;
                      });
                    },
                    child: const Text("Prove Keccak")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
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
                        var proofResult = _circomKeccakProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/keccak.zkey", proofResult!, ProofLib.arkworks); // Using Keccak zkey
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
                        _circomKeccakValid = valid;
                      });
                    },
                    child: const Text("Verify Keccak")),
              ),
            ],
          ),
          if (_circomKeccakProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Keccak Proof is valid: ${_circomKeccakValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Keccak Proof inputs: ${_circomKeccakProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Keccak Proof: ${_circomKeccakProofResult?.proof ?? ""}'),
                ),
              ],
            ),
          
          // Visual divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Divider(
              thickness: 2,
              color: Colors.grey[400],
            ),
          ),
          
          // SHA256 Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'SHA256 Proof Generation\nUsing hardcoded input: "Hello World! This is a test msg."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
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
                        // Hardcoded SHA256 input: "Hello World! This is a test msg." as byte array
                        var inputs = '''{
    "in": [
        "40",
        "202",
        "21",
        "44",
        "148",
        "225",
        "219",
        "127",
        "125",
        "137",
        "45",
        "39",
        "181",
        "182",
        "116",
        "221",
        "65",
        "64",
        "40",
        "99",
        "92",
        "60",
        "3",
        "33",
        "40",
        "159",
        "154",
        "251",
        "14",
        "238",
        "144",
        "106"
    ]
}''';
                        proofResult =
                            await _moproFlutterPlugin.generateCircomProof(
                                "assets/sha256.zkey", inputs, ProofLib.arkworks);  // Using SHA256 zkey
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
                        _circomSha256ProofResult = proofResult;
                      });
                    },
                    child: const Text("Prove SHA256")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () async {
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
                        var proofResult = _circomSha256ProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/sha256.zkey", proofResult!, ProofLib.arkworks); // Using SHA256 zkey
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
                        _circomSha256Valid = valid;
                      });
                    },
                    child: const Text("Verify SHA256")),
              ),
            ],
          ),
          if (_circomSha256ProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('SHA256 Proof is valid: ${_circomSha256Valid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('SHA256 Proof inputs: ${_circomSha256ProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('SHA256 Proof: ${_circomSha256ProofResult?.proof ?? ""}'),
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
                    if (_noirMimcVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/mimc.vk');
                        _noirMimcVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _noirMimcVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
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
                      _noirMimcVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _noirMimcProofResult = proof;
                      _noirMimcValid = null;
                      _noirKeccakProofResult = null;
                      _noirPoseidonProofResult = null;
                      _noirKeccakValid = null;
                      _noirPoseidonValid = null;
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
                  if (isProving || _noirMimcProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/mimc.json",
                      _noirMimcProofResult!,
                      onChain,
                      _noirMimcVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _noirMimcValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _noirMimcValid = false; });
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
                    if (_noirKeccakVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/keccak.vk');
                        _noirKeccakVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _noirKeccakVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
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
                      _noirKeccakVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _noirKeccakProofResult = proof;
                      _noirKeccakValid = null;
                      _noirMimcProofResult = null;
                      _noirPoseidonProofResult = null;
                      _noirMimcValid = null;
                      _noirPoseidonValid = null;
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
                  if (isProving || _noirKeccakProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/keccak256.json",
                      _noirKeccakProofResult!,
                      onChain,
                      _noirKeccakVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _noirKeccakValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _noirKeccakValid = false; });
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
                    if (_noirPoseidonVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/poseidon.vk');
                        _noirPoseidonVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _noirPoseidonVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
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
                      _noirPoseidonVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _noirPoseidonProofResult = proof;
                      _noirPoseidonValid = null;
                      _noirMimcProofResult = null;
                      _noirKeccakProofResult = null;
                      _noirMimcValid = null;
                      _noirKeccakValid = null;
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
                    if (_noirPedersenVerificationKey == null) {
                      try {
                        final vkAsset = await rootBundle.load('assets/pedersen.vk');
                        _noirPedersenVerificationKey = vkAsset.buffer.asUint8List();
                      } catch (e) {
                        _noirPedersenVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
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
                      _noirPedersenVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() {
                      // show the newly generated proof and clear other circuit proofs
                      _noirPedersenProofResult = proof;
                      _noirPedersenValid = null;
                      _noirMimcProofResult = null;
                      _noirKeccakProofResult = null;
                      _noirPoseidonProofResult = null;
                      _noirMimcValid = null;
                      _noirKeccakValid = null;
                      _noirPoseidonValid = null;
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
                  if (isProving || _noirPedersenProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = true;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/pedersen.json",
                      _noirPedersenProofResult!,
                      onChain,
                      _noirPedersenVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _noirPedersenValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _noirPedersenValid = false; });
                  } finally {
                    if (mounted) setState(() { isProving = false; });
                  }
                },
                child: const Text('Verify Pedersen Proof'),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (isProving || _noirPoseidonProofResult == null) return;
                  setState(() { _error = null; isProving = true; });
                  try {
                    const bool onChain = false;
                    const bool lowMemoryMode = false;
                    final valid = await _moproFlutterPlugin.verifyNoirProof(
                      "assets/poseidon.json",
                      _noirPoseidonProofResult!,
                      onChain,
                      _noirPoseidonVerificationKey!,
                      lowMemoryMode,
                    );
                    setState(() { _noirPoseidonValid = valid; });
                  } on Exception catch (e) {
                    setState(() { _error = e; _noirPoseidonValid = false; });
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
              if (_noirMimcProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MiMC proof is valid: ${_noirMimcValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MiMC proof: ${_noirMimcProofResult}'),
                ),
              ],
              if (_noirKeccakProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Keccak proof is valid: ${_noirKeccakValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Keccak proof: ${_noirKeccakProofResult}'),
                ),
              ],
              if (_noirPoseidonProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Poseidon proof is valid: ${_noirPoseidonValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Poseidon proof: ${_noirPoseidonProofResult}'),
                ),
              ],
              if (_noirPedersenProofResult != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pedersen proof is valid: ${_noirPedersenValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pedersen proof: ${_noirPedersenProofResult}'),
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
