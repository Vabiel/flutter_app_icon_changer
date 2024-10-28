import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';

/// A class containing static instances of custom icons.
class CustomIcons {
  /// The purple icon instance.
  static final purpleIcon = PurpleIcon();

  /// The red icon instance.
  static final redIcon = RedIcon();

  /// The default icon instance.
  static final defaultIcon = DefaultIcon();

  /// A list of all available [CustomIcon] instances.
  static final List<CustomIcon> values = [
    CustomIcons.purpleIcon,
    CustomIcons.redIcon,
    CustomIcons.defaultIcon,
  ];
}

/// A sealed class representing a custom app icon with a preview path.
///
/// This class cannot be extended outside of its library.
sealed class CustomIcon extends AppIcon {
  /// The file path to the preview image of the icon.
  final String previewPath;

  CustomIcon({
    required this.previewPath,
    required super.iOSIcon,
    required super.androidIcon,
    required super.isDefaultIcon,
  });

  /// Creates a [CustomIcon] instance from a string [icon] name.
  ///
  /// Returns the corresponding [CustomIcon] if found;
  /// Otherwise, returns the default icon.
  factory CustomIcon.fromString(String? icon) {
    if (icon == null) return CustomIcons.defaultIcon;

    return CustomIcons.values.firstWhere(
      (e) => e.iOSIcon == icon || e.androidIcon == icon,
      orElse: () => CustomIcons.defaultIcon,
    );
  }
}

/// A final class representing the red custom icon.
final class RedIcon extends CustomIcon {
  RedIcon()
      : super(
          iOSIcon: 'AppIcon1',
          androidIcon: 'MainActivityAlias1',
          previewPath: 'assets/icons/icon1.png',
          isDefaultIcon: false,
        );
}

/// A final class representing the purple custom icon.
final class PurpleIcon extends CustomIcon {
  PurpleIcon()
      : super(
          iOSIcon: 'AppIcon2',
          androidIcon: 'MainActivityAlias2',
          previewPath: 'assets/icons/icon2.png',
          isDefaultIcon: false,
        );
}

/// A final class representing the default app icon.
final class DefaultIcon extends CustomIcon {
  DefaultIcon()
      : super(
          iOSIcon: 'AppIcon',
          androidIcon: 'MainActivity',
          previewPath: 'assets/icons/default_icon.png',
          isDefaultIcon: true,
        );
}
