import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_flutter/mopro_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMoproFlutter platform = MethodChannelMoproFlutter();
  const MethodChannel channel = MethodChannel('mopro_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    var inputs = <String, List<String>>{};
    inputs["a"] = ["3"];
    inputs["b"] = ["5"];
    expect(await platform.generateCircomProof("zkey", inputs), '42');
  });
}
