import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_app_icon_changer_method_channel.dart';

abstract class FlutterAppIconChangerPlatform extends PlatformInterface {
  /// Constructs a FlutterAppIconChangerPlatform.
  FlutterAppIconChangerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAppIconChangerPlatform _instance =
      MethodChannelFlutterAppIconChanger();

  /// The default instance of [FlutterAppIconChangerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAppIconChanger].
  static FlutterAppIconChangerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAppIconChangerPlatform] when
  /// they register themselves.
  static set instance(FlutterAppIconChangerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> changeIcon(String? icon) {
    throw UnimplementedError('changeIcon() has not been implemented.');
  }

  Future<String?> getCurrentIcon() {
    throw UnimplementedError('getCurrentIcon() has not been implemented.');
  }

  Future<bool> isSupported() async {
    throw UnimplementedError('isSupported() has not been implemented.');
  }

  Future<void> setAvailableIcons(AppIconsSet iconsSet) async {
    throw UnimplementedError('setAvailableIcons() has not been implemented.');
  }
}

abstract class AppIconsSet {
  final List<AppIcon> iconsSet;

  AppIconsSet({
    required this.iconsSet,
  }) : assert(iconsSet.isNotEmpty);

  List<Map<String, dynamic>> toDataSet() {
    return iconsSet.map((e) => e.data).toList();
  }

  @override
  String toString() {
    return 'AppIconsSet{iconsSet: $iconsSet}';
  }
}

abstract class AppIcon {
  final String iOSIcon;
  final String androidIcon;
  final bool isDefaultIcon;

  AppIcon({
    required this.iOSIcon,
    required this.androidIcon,
    required this.isDefaultIcon,
  })  : assert(iOSIcon.isNotEmpty),
        assert(androidIcon.isNotEmpty);

  String get currentIcon => Platform.isIOS ? iOSIcon : androidIcon;

  Map<String, dynamic> get data {
    return {
      'icon': currentIcon,
      'isDefaultIcon': isDefaultIcon,
    };
  }

  @override
  String toString() {
    return 'AppIcon{iOSIcon: $iOSIcon, androidIcon: $androidIcon, isDefaultIcon: $isDefaultIcon}';
  }
}
