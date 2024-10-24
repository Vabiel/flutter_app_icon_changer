import 'package:flutter/cupertino.dart';
import 'package:flutter_app_icon_changer/src/models/models.dart';
import 'package:flutter_app_icon_changer/src/plugin/flutter_app_icon_changer_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_icon_changer/src/plugin/flutter_app_icon_changer.dart';
import 'package:flutter_app_icon_changer/src/plugin/flutter_app_icon_changer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAppIconChangerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAppIconChangerPlatform {
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
  final FlutterAppIconChangerPlatform initialPlatform =
      FlutterAppIconChangerPlatform.instance;

  final fakePlatform = MockFlutterAppIconChangerPlatform();
  FlutterAppIconChangerPlatform.instance = fakePlatform;
  final flutterAppIconChangerPlugin =
      FlutterAppIconChanger(iconsSet: AppIconsSetTest());

  test('$MethodChannelFlutterAppIconChanger is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAppIconChanger>());
  });

  test('isSupported', () async {
    expect(await flutterAppIconChangerPlugin.isSupported(), true);
  });

  test('getCurrentIcon', () async {
    expect(await flutterAppIconChangerPlugin.getCurrentIcon(), 'defaultIcon');
  });

  test('setAvailableIcons', () async {
    await flutterAppIconChangerPlugin.testSetAvailableIcons();

    // Verify no exception is thrown and method completes
    expect(true, isTrue);
  });

  test('changeIcon', () async {
    expect(await flutterAppIconChangerPlugin.changeIcon('newIcon'), true);
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
