import 'package:flutter_app_icon_changer/src/models/models.dart';

/// An abstract class representing a set of app icons.
abstract class AppIconsSet {
  /// A list containing the icons in the set.
  ///
  /// Must not be empty and must contain at least one default icon.
  final List<AppIcon> iconsSet;

  AppIconsSet({
    required this.iconsSet,
  })  : assert(
          iconsSet.isNotEmpty,
          'The icon set should not be empty',
        ),
        assert(
          iconsSet.any((e) => e.isDefaultIcon),
          'There should be at least one default icon in the icon set',
        );

  /// Converts the icon set into a list of data maps.
  ///
  /// Each icon in the set is converted to a `Map<String, dynamic>` using its [data] getter.
  List<Map<String, dynamic>> toDataSet() {
    return iconsSet.map((e) => e.data).toList();
  }
}
