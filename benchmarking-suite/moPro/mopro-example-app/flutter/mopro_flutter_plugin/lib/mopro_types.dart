import 'dart:typed_data';

class G1Point {
  final String x;
  final String y;
  final String z;

  G1Point(this.x, this.y, this.z);

  @override
  String toString() {
    return "G1Point(\nx: $x, \ny: $y, \nz: $z)";
  }
}

class G2Point {
  final List<String> x;
  final List<String> y;
  final List<String> z;

  G2Point(this.x, this.y, this.z);

  @override
  String toString() {
    return "G2Point(\nx: $x, \ny: $y, \nz: $z)";
  }
}

class ProofCalldata {
  final G1Point a;
  final G2Point b;
  final G1Point c;
  final String protocol;
  final String curve;

  ProofCalldata(this.a, this.b, this.c, this.protocol, this.curve);

  @override
  String toString() {
    return "ProofCalldata(\na: $a, \nb: $b, \nc: $c, \nprotocol: $protocol, \ncurve: $curve)";
  }
}

enum ProofLib { arkworks, rapidsnark }

class CircomProofResult {
  final ProofCalldata proof;
  final List<String> inputs;

  CircomProofResult(this.proof, this.inputs);

  factory CircomProofResult.fromMap(Map<Object?, Object?> proofResult) {
    var proof = proofResult["proof"] as Map<Object?, Object?>;
    var inputs = proofResult["inputs"] as List;
    var a = proof["a"] as Map<Object?, Object?>;
    var b = proof["b"] as Map<Object?, Object?>;
    var c = proof["c"] as Map<Object?, Object?>;

    var g1a = G1Point(a["x"] as String, a["y"] as String, a["z"] as String);
    var g2b = G2Point((b["x"] as List).cast<String>(),
        (b["y"] as List).cast<String>(), (b["z"] as List).cast<String>());
    var g1c = G1Point(c["x"] as String, c["y"] as String, c["z"] as String);
    return CircomProofResult(
        ProofCalldata(g1a, g2b, g1c, proof["protocol"] as String,
            proof["curve"] as String),
        inputs.cast<String>());
  }

  Map<String, dynamic> toMap() {
    return {
      "proof": {
        "a": {"x": proof.a.x, "y": proof.a.y, "z": proof.a.z},
        "b": {"x": proof.b.x, "y": proof.b.y, "z": proof.b.z},
        "c": {"x": proof.c.x, "y": proof.c.y, "z": proof.c.z},
        "protocol": proof.protocol,
        "curve": proof.curve
      },
      "inputs": inputs
    };
  }
}

class Halo2ProofResult {
  final Uint8List proof;
  final Uint8List inputs;

  Halo2ProofResult(this.proof, this.inputs);

  factory Halo2ProofResult.fromMap(Map<Object?, Object?> proofResult) {
    return Halo2ProofResult(
        proofResult["proof"] as Uint8List, proofResult["inputs"] as Uint8List);
  }

  Map<String, dynamic> toMap() {
    return {"proof": proof, "inputs": inputs};
  }
}
