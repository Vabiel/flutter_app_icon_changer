import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer_platform_interface.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCustomIconChangerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCustomIconChangerPlatform {
  @override
  Future<bool?> changeIcon(String? iconName) => Future.value(true);

  @override
  Future<String?> getCurrentIcon() => Future.value('defaultIcon');

  @override
  Future<bool> isSupported() => Future.value(true);

  @override
  Future<void> setAvailableIcons(AppIconsSet iconsSet) async {}
}

void main() {
  final FlutterCustomIconChangerPlatform initialPlatform =
      FlutterCustomIconChangerPlatform.instance;

  final fakePlatform = MockFlutterCustomIconChangerPlatform();
  FlutterCustomIconChangerPlatform.instance = fakePlatform;
  final flutterCustomIconChangerPlugin =
      FlutterCustomIconChanger(icons: AppIconsSetTest());

  test('$MethodChannelFlutterCustomIconChanger is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterCustomIconChanger>());
  });

  test('isSupported', () async {
    expect(await flutterCustomIconChangerPlugin.isSupported(), true);
  });

  test('getCurrentIcon', () async {
    expect(
        await flutterCustomIconChangerPlugin.getCurrentIcon(), 'defaultIcon');
  });

  test('setAvailableIcons', () async {
    await flutterCustomIconChangerPlugin
        .testSetAvailableIcons(AppIconsSetTest());

    // Verify no exception is thrown and method completes
    expect(true, isTrue);
  });

  test('changeIcon', () async {
    expect(await flutterCustomIconChangerPlugin.changeIcon('newIcon'), true);
  });
}

@visibleForTesting
class AppIconsSetTest extends AppIconsSet {
  AppIconsSetTest() : super(iconsSet: [AppIconTest()]);
}

@visibleForTesting
class AppIconTest extends AppIcon {
  AppIconTest()
      : super(
          iOSIcon: 'ios',
          androidIcon: 'android',
          isDefaultIcon: true,
        );
}
