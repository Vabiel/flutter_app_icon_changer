import 'dart:io';

/// An abstract class representing an individual app icon.
abstract class AppIcon {
  /// The name of the icon for iOS platform.
  final String iOSIcon;

  /// The name of the icon for Android platform.
  final String androidIcon;

  /// Indicates whether this icon is the default icon.
  final bool isDefaultIcon;

  AppIcon({
    required this.iOSIcon,
    required this.androidIcon,
    required this.isDefaultIcon,
  })  : assert(
          iOSIcon.isNotEmpty,
          'iOS icon should not be empty',
        ),
        assert(
          androidIcon.isNotEmpty,
          'Android icon should not be empty',
        );

  /// Gets the icon name based on the current platform.
  ///
  /// Returns [iOSIcon] if the platform is iOS, otherwise returns [androidIcon].
  String get currentIcon => Platform.isIOS ? iOSIcon : androidIcon;

  /// Returns a map containing the icon data.
  ///
  /// The map includes the current icon name and whether it is the default icon.
  Map<String, dynamic> get data {
    return {
      'icon': currentIcon,
      'isDefaultIcon': isDefaultIcon,
    };
  }
}
