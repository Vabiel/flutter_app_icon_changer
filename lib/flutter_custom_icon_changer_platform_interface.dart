import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_custom_icon_changer_method_channel.dart';

abstract class FlutterCustomIconChangerPlatform extends PlatformInterface {
  /// Constructs a FlutterCustomIconChangerPlatform.
  FlutterCustomIconChangerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCustomIconChangerPlatform _instance =
      MethodChannelFlutterCustomIconChanger();

  /// The default instance of [FlutterCustomIconChangerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCustomIconChanger].
  static FlutterCustomIconChangerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCustomIconChangerPlatform] when
  /// they register themselves.
  static set instance(FlutterCustomIconChangerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> changeIcon(String? iconName) {
    throw UnimplementedError('changeIcon() has not been implemented.');
  }

  Future<String?> getCurrentIcon() {
    throw UnimplementedError('getCurrentIcon() has not been implemented.');
  }
}
