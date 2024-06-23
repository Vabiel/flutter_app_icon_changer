import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer_method_channel.dart';

import 'flutter_custom_icon_changer_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterCustomIconChanger platform =
      MethodChannelFlutterCustomIconChanger();
  const MethodChannel channel = MethodChannel('flutter_custom_icon_changer');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isSupported':
            return true;
          case 'getCurrentIcon':
            return 'defaultIcon';
          case 'changeIcon':
            return true;
          case 'setAvailableIcons':
            return null;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('isSupported', () async {
    expect(await platform.isSupported(), true);
  });

  test('getCurrentIcon', () async {
    expect(await platform.getCurrentIcon(), 'defaultIcon');
  });

  test('setAvailableIcons', () async {
    await platform.setAvailableIcons(AppIconsSetTest());

    // Verify no exception is thrown and method completes
    expect(true, isTrue);
  });

  test('changeIcon', () async {
    expect(await platform.changeIcon('newIcon'), true);
  });
}

