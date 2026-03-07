import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_flutter/mopro_flutter.dart';
import 'package:mopro_flutter/mopro_flutter_platform_interface.dart';
import 'package:mopro_flutter/mopro_flutter_method_channel.dart';
import 'package:mopro_flutter/mopro_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoproFlutterPlatform
    with MockPlatformInterfaceMixin
    implements MoproFlutterPlatform {
  @override
  Future<Groth16ProofResult?> generateGroth16Proof(
          String zkeyPath, String inputs, ProofLib proofLib) =>
      Future.value(Groth16ProofResult(
        ProofCalldata(
          G1Point("1", "2", "3"),
          G2Point(["1", "2"], ["3", "4"], ["5", "6"]),
          G1Point("3", "4", "5"),
          "protocol",
          "curve"
        ),
        ["3", "5"],
      ));
}

void main() {
  final MoproFlutterPlatform initialPlatform = MoproFlutterPlatform.instance;

  test('$MethodChannelMoproFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMoproFlutter>());
  });

  test('getPlatformVersion', () async {
    MoproFlutter moproFlutterPlugin = MoproFlutter();
    MockMoproFlutterPlatform fakePlatform = MockMoproFlutterPlatform();
    MoproFlutterPlatform.instance = fakePlatform;

    var inputs = "{\"a\":[\"3\"],\"b\":[\"5\"]}";
    expect(
        await moproFlutterPlugin.generateGroth16Proof(
            "multiplier2_final.zkey", inputs, ProofLib.arkworks),
        Groth16ProofResult(
          ProofCalldata(
            G1Point("1", "2", "3"),
            G2Point(["1", "2"], ["3", "4"], ["5", "6"]),
            G1Point("3", "4", "5"),
            "protocol",
            "curve"
          ),
          ["3", "5"],
        ));
  });
}
