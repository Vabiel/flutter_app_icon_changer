import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer_platform_interface.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCustomIconChangerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCustomIconChangerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> changeIcon(String? iconName) {
    return Future.value(true);
  }

  @override
  Future<String?> getCurrentIcon() {
    return Future.value(null);
  }
}

void main() {
  final FlutterCustomIconChangerPlatform initialPlatform =
      FlutterCustomIconChangerPlatform.instance;

  test('$MethodChannelFlutterCustomIconChanger is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterCustomIconChanger>());
  });

  test('getPlatformVersion', () async {
    FlutterCustomIconChanger flutterCustomIconChangerPlugin =
        FlutterCustomIconChanger();
    MockFlutterCustomIconChangerPlatform fakePlatform =
        MockFlutterCustomIconChangerPlatform();
    FlutterCustomIconChangerPlatform.instance = fakePlatform;

    expect(await flutterCustomIconChangerPlugin.getPlatformVersion(), '42');
  });
}
