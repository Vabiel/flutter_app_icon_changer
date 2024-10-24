import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';
import 'package:flutter_app_icon_changer/flutter_app_icon_changer_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterAppIconChangerPlugin = FlutterAppIconChanger(
    iconsSet: CustomIconsSet(),
  );

  var _currentIcon = CustomIcons.byDefault;
  var _isSupported = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _isSupported = await _flutterAppIconChangerPlugin.isSupported();
    if (_isSupported) {
      final currentIcon = await _flutterAppIconChangerPlugin.getCurrentIcon();

      if (!mounted) return;

      setState(() {
        _currentIcon = CustomIcons.fromString(currentIcon);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Icon changer example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Spacer(),
              if (!_isSupported) ...[
                const Text('Changing the icon is not supported on this device'),
                const SizedBox(height: 8),
              ],
              FittedBox(
                child: Opacity(
                  opacity: _isSupported ? 1 : .5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(CustomIcons.first),
                        const SizedBox(width: 8),
                        _buildButton(CustomIcons.second),
                        const SizedBox(width: 8),
                        _buildButton(CustomIcons.byDefault),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(CustomIcons icon) {
    final border = BorderRadius.circular(8.0);

    return InkWell(
      borderRadius: border,
      onTap: _isSupported ? () => _changeIcon(icon) : null,
      child: Card(
        shape: icon == _currentIcon ? _buildBorder(border) : null,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: _buildPreviewIcon(
            icon,
          ),
        ),
      ),
    );
  }

  OutlinedBorder _buildBorder(BorderRadius borderRadius) {
    return RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2.0,
      ),
    );
  }

  Widget _buildPreviewIcon(CustomIcons icon, {double size = 100}) {
    return Image.asset(
      icon.previewPath,
      fit: BoxFit.contain,
      width: size,
      height: size,
    );
  }

  Future<void> _changeIcon(CustomIcons icon) async {
    final currentIcon = icon.currentIcon;
    try {
      await _flutterAppIconChangerPlugin.changeIcon(currentIcon);
      setState(() {
        _currentIcon = icon;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to change icon: '${e.message}'.");
    }
  }
}

class CustomIconsSet extends AppIconsSet {
  CustomIconsSet() : super(iconsSet: CustomIcons.values);
}

enum CustomIcons implements AppIcon {
  first(
    'AppIcon1',
    'MainActivityAlias1',
    previewPath: 'assets/icons/icon1.png',
  ),
  second('AppIcon2', 'MainActivityAlias2',
      previewPath: 'assets/icons/icon2.png'),
  byDefault(
    'AppIcon',
    'MainActivity',
    previewPath: 'assets/icons/default_icon.png',
    isDefaultIcon: true,
  );

  @override
  final String iOSIcon;
  @override
  final String androidIcon;
  @override
  final bool isDefaultIcon;

  final String previewPath;

  const CustomIcons(
    this.iOSIcon,
    this.androidIcon, {
    required this.previewPath,
    this.isDefaultIcon = false,
  });

  @override
  Map<String, dynamic> get data {
    return {
      'icon': currentIcon,
      'isDefaultIcon': isDefaultIcon,
    };
  }

  @override
  String get currentIcon => Platform.isIOS ? iOSIcon : androidIcon;

  factory CustomIcons.fromString(String? icon) {
    if (icon == null) return CustomIcons.byDefault;

    return CustomIcons.values.firstWhere(
      (e) => e.iOSIcon == icon || e.androidIcon == icon,
      orElse: () => CustomIcons.byDefault,
    );
  }
}
