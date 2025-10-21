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
  CircomProofResult? _circomBlake2s256ProofResult;
  CircomProofResult? _circomMimc256ProofResult;
  CircomProofResult? _circomPedersenProofResult;
  CircomProofResult? _circomPoseidonProofResult;
  bool? _circomKeccakValid;
  bool? _circomSha256Valid;
  bool? _circomBlake2s256Valid;
  bool? _circomMimc256Valid;
  bool? _circomPedersenValid;
  bool? _circomPoseidonValid;
  
  // Halo2 proofs
  Halo2ProofResult? _halo2ProofResult;
  bool? _halo2Valid;
  
  // Noir proofs & VKs
  Uint8List? _noirMimcProofResult;
  Uint8List? _noirKeccakProofResult;
  Uint8List? _noirPoseidonProofResult;
  Uint8List? _noirPedersenProofResult;
  Uint8List? _noirSha256ProofResult;

  Uint8List? _noirMimcVerificationKey;
  Uint8List? _noirKeccakVerificationKey;
  Uint8List? _noirPoseidonVerificationKey;
  Uint8List? _noirPedersenVerificationKey;
  Uint8List? _noirSha256VerificationKey;

  bool? _noirMimcValid;
  bool? _noirKeccakValid;
  bool? _noirPoseidonValid;
  bool? _noirPedersenValid;
  bool? _noirSha256Valid;
  
  String _selectedNoirHashFunction = 'MiMC';
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
          
          // Visual divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Divider(
              thickness: 2,
              color: Colors.grey[400],
            ),
          ),
          
          // Blake2s256 Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Blake2s256 Proof Generation\nUsing hardcoded input: "Hello World! This is a test msg."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.purple[800],
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
                        // Hardcoded Blake2s256 input: "Hello World! This is a test msg." as byte array
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
                                "assets/blake2s256.zkey", inputs, ProofLib.arkworks);
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
                        _circomBlake2s256ProofResult = proofResult;
                      });
                    },
                    child: const Text("Prove Blake2s256")),
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
                        var proofResult = _circomBlake2s256ProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/blake2s256.zkey", proofResult!, ProofLib.arkworks);
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
                        _circomBlake2s256Valid = valid;
                      });
                    },
                    child: const Text("Verify Blake2s256")),
              ),
            ],
          ),
          if (_circomBlake2s256ProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Blake2s256 Proof is valid: ${_circomBlake2s256Valid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Blake2s256 Proof inputs: ${_circomBlake2s256ProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Blake2s256 Proof: ${_circomBlake2s256ProofResult?.proof ?? ""}'),
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
          
          // MiMC256 Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'MiMC256 Proof Generation\nUsing hardcoded field element input',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange[800],
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
                        // MiMC256 uses field elements as input
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
                                "assets/mimc256.zkey", inputs, ProofLib.arkworks);
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
                        _circomMimc256ProofResult = proofResult;
                      });
                    },
                    child: const Text("Prove MiMC256")),
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
                        var proofResult = _circomMimc256ProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/mimc256.zkey", proofResult!, ProofLib.arkworks);
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
                        _circomMimc256Valid = valid;
                      });
                    },
                    child: const Text("Verify MiMC256")),
              ),
            ],
          ),
          if (_circomMimc256ProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MiMC256 Proof is valid: ${_circomMimc256Valid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('MiMC256 Proof inputs: ${_circomMimc256ProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MiMC256 Proof: ${_circomMimc256ProofResult?.proof ?? ""}'),
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
          
          // Pedersen Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Pedersen Proof Generation\nUsing hardcoded field element inputs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red[800],
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
                        // Pedersen uses field elements as input
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
                                "assets/pedersen.zkey", inputs, ProofLib.arkworks);
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
                        _circomPedersenProofResult = proofResult;
                      });
                    },
                    child: const Text("Prove Pedersen")),
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
                        var proofResult = _circomPedersenProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/pedersen.zkey", proofResult!, ProofLib.arkworks);
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
                        _circomPedersenValid = valid;
                      });
                    },
                    child: const Text("Verify Pedersen")),
              ),
            ],
          ),
          if (_circomPedersenProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pedersen Proof is valid: ${_circomPedersenValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Pedersen Proof inputs: ${_circomPedersenProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pedersen Proof: ${_circomPedersenProofResult?.proof ?? ""}'),
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
          
          // Poseidon Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Poseidon Proof Generation\nUsing hardcoded field element inputs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal[800],
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
                        // Poseidon uses field elements as input
                        var inputs = '''{
    "in": [
        "72",
        "101",
        "108",
        "108",
        "111",
        "32",
        "87",
        "111"
    ]
}
''';
                        proofResult =
                            await _moproFlutterPlugin.generateCircomProof(
                                "assets/poseidon.zkey", inputs, ProofLib.arkworks);
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
                        _circomPoseidonProofResult = proofResult;
                      });
                    },
                    child: const Text("Prove Poseidon")),
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
                        var proofResult = _circomPoseidonProofResult;
                        valid = await _moproFlutterPlugin.verifyCircomProof(
                            "assets/poseidon.zkey", proofResult!, ProofLib.arkworks);
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
                        _circomPoseidonValid = valid;
                      });
                    },
                    child: const Text("Verify Poseidon")),
              ),
            ],
          ),
          if (_circomPoseidonProofResult != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Poseidon Proof is valid: ${_circomPoseidonValid ?? false}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Poseidon Proof inputs: ${_circomPoseidonProofResult?.inputs ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Poseidon Proof: ${_circomPoseidonProofResult?.proof ?? ""}'),
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
              child: Text(
                _error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          
          // Hash Function Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Select Hash Function',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedNoirHashFunction,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'MiMC', child: Text('MiMC')),
                      DropdownMenuItem(value: 'Keccak256', child: Text('Keccak256')),
                      DropdownMenuItem(value: 'Poseidon', child: Text('Poseidon')),
                      DropdownMenuItem(value: 'Pedersen', child: Text('Pedersen')),
                      DropdownMenuItem(value: 'SHA256', child: Text('SHA256')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedNoirHashFunction = newValue!;
                        _error = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Hardcoded input display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Using hardcoded 32-byte input',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ),
          
          // Prove and Verify Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Generate Proof'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => _generateNoirProof(_selectedNoirHashFunction),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.verified),
                  label: const Text('Verify Proof'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => _verifyNoirProof(_selectedNoirHashFunction),
                ),
              ),
            ],
          ),
          
          // Display proof results based on selected hash function
          _buildNoirProofResults(),
        ],
      ),
    );
  }
  
  Widget _buildNoirProofResults() {
    Uint8List? currentProof;
    bool? currentValid;
    
    switch (_selectedNoirHashFunction) {
      case 'MiMC':
        currentProof = _noirMimcProofResult;
        currentValid = _noirMimcValid;
        break;
      case 'Keccak256':
        currentProof = _noirKeccakProofResult;
        currentValid = _noirKeccakValid;
        break;
      case 'Poseidon':
        currentProof = _noirPoseidonProofResult;
        currentValid = _noirPoseidonValid;
        break;
      case 'Pedersen':
        currentProof = _noirPedersenProofResult;
        currentValid = _noirPedersenValid;
        break;
      case 'SHA256':
        currentProof = _noirSha256ProofResult;
        currentValid = _noirSha256Valid;
        break;
    }
    
    if (currentProof == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentValid == true ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                currentValid == true ? Icons.check_circle : Icons.pending,
                color: currentValid == true ? Colors.green : Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                '$_selectedNoirHashFunction Proof',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Valid: ${currentValid ?? "Not verified yet"}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: currentValid == true ? Colors.green[700] : Colors.orange[700],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Proof Data:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                currentProof.toString(),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _generateNoirProof(String hashFunction) async {
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
      
      String assetPath;
      String srsPath;
      bool onChain;
      Uint8List? verificationKey;
      const bool lowMemoryMode = false;
      
      switch (hashFunction) {
        case 'MiMC':
          assetPath = "assets/mimc.json";
          srsPath = "assets/mimc.srs";
          onChain = true;
          if (_noirMimcVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/mimc.vk');
              _noirMimcVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
              _noirMimcVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirMimcVerificationKey;
          break;
        case 'Keccak256':
          assetPath = "assets/keccak256.json";
          srsPath = "assets/keccak256.srs";
          onChain = true;
          if (_noirKeccakVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/keccak.vk');
              _noirKeccakVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
              _noirKeccakVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirKeccakVerificationKey;
          break;
        case 'Poseidon':
          assetPath = "assets/poseidon.json";
          srsPath = "assets/poseidon.srs";
          onChain = false;
          if (_noirPoseidonVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/poseidon.vk');
              _noirPoseidonVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
              _noirPoseidonVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirPoseidonVerificationKey;
          break;
        case 'Pedersen':
          assetPath = "assets/pedersen.json";
          srsPath = "assets/pedersen.srs";
          onChain = true;
          if (_noirPedersenVerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/pedersen.vk');
              _noirPedersenVerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
              _noirPedersenVerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirPedersenVerificationKey;
          break;
        case 'SHA256':
          assetPath = "assets/sha256.json";
          srsPath = "assets/sha256.srs";
          onChain = true;
          if (_noirSha256VerificationKey == null) {
            try {
              final vkAsset = await rootBundle.load('assets/sha256.vk');
              _noirSha256VerificationKey = vkAsset.buffer.asUint8List();
            } catch (e) {
              _noirSha256VerificationKey = await _moproFlutterPlugin.getNoirVerificationKey(
                assetPath, srsPath, onChain, lowMemoryMode,
              );
            }
          }
          verificationKey = _noirSha256VerificationKey;
          break;
        default:
          throw Exception('Unknown hash function: $hashFunction');
      }
      
      final proof = await _moproFlutterPlugin.generateNoirProof(
        assetPath,
        srsPath,
        hardcodedInputs,
        onChain,
        verificationKey!,
        lowMemoryMode,
      );
      
      setState(() {
        switch (hashFunction) {
          case 'MiMC':
            _noirMimcProofResult = proof;
            _noirMimcValid = null;
            break;
          case 'Keccak256':
            _noirKeccakProofResult = proof;
            _noirKeccakValid = null;
            break;
          case 'Poseidon':
            _noirPoseidonProofResult = proof;
            _noirPoseidonValid = null;
            break;
          case 'Pedersen':
            _noirPedersenProofResult = proof;
            _noirPedersenValid = null;
            break;
          case 'SHA256':
            _noirSha256ProofResult = proof;
            _noirSha256Valid = null;
            break;
        }
      });
    } on Exception catch (e) {
      setState(() { _error = e; });
    } finally {
      if (mounted) setState(() { isProving = false; });
    }
  }
  
  Future<void> _verifyNoirProof(String hashFunction) async {
    if (isProving) return;
    
    setState(() {
      _error = null;
      isProving = true;
    });
    
    try {
      String assetPath;
      bool onChain;
      Uint8List? proof;
      Uint8List? verificationKey;
      const bool lowMemoryMode = false;
      
      switch (hashFunction) {
        case 'MiMC':
          assetPath = "assets/mimc.json";
          onChain = true;
          proof = _noirMimcProofResult;
          verificationKey = _noirMimcVerificationKey;
          break;
        case 'Keccak256':
          assetPath = "assets/keccak256.json";
          onChain = true;
          proof = _noirKeccakProofResult;
          verificationKey = _noirKeccakVerificationKey;
          break;
        case 'Poseidon':
          assetPath = "assets/poseidon.json";
          onChain = false;
          proof = _noirPoseidonProofResult;
          verificationKey = _noirPoseidonVerificationKey;
          break;
        case 'Pedersen':
          assetPath = "assets/pedersen.json";
          onChain = true;
          proof = _noirPedersenProofResult;
          verificationKey = _noirPedersenVerificationKey;
          break;
        case 'SHA256':
          assetPath = "assets/sha256.json";
          onChain = true;
          proof = _noirSha256ProofResult;
          verificationKey = _noirSha256VerificationKey;
          break;
        default:
          throw Exception('Unknown hash function: $hashFunction');
      }
      
      if (proof == null) {
        throw Exception('No proof available. Generate a proof first.');
      }
      
      if (verificationKey == null) {
        throw Exception('No verification key available.');
      }
      
      final valid = await _moproFlutterPlugin.verifyNoirProof(
        assetPath,
        proof,
        onChain,
        verificationKey,
        lowMemoryMode,
      );
      
      setState(() {
        switch (hashFunction) {
          case 'MiMC':
            _noirMimcValid = valid;
            break;
          case 'Keccak256':
            _noirKeccakValid = valid;
            break;
          case 'Poseidon':
            _noirPoseidonValid = valid;
            break;
          case 'Pedersen':
            _noirPedersenValid = valid;
            break;
          case 'SHA256':
            _noirSha256Valid = valid;
            break;
        }
      });
    } on Exception catch (e) {
      setState(() { 
        _error = e;
        switch (hashFunction) {
          case 'MiMC':
            _noirMimcValid = false;
            break;
          case 'Keccak256':
            _noirKeccakValid = false;
            break;
          case 'Poseidon':
            _noirPoseidonValid = false;
            break;
          case 'Pedersen':
            _noirPedersenValid = false;
            break;
          case 'SHA256':
            _noirSha256Valid = false;
            break;
        }
      });
    } finally {
      if (mounted) setState(() { isProving = false; });
    }
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
