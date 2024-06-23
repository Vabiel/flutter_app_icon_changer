import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterCustomIconChangerPlugin = FlutterCustomIconChanger(
    icons: CustomIconsSet(),
  );

  var _currentIcon = CustomIcons.byDefault;
  var _isSupported = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _isSupported = await _flutterCustomIconChangerPlugin.isSupported();
    if (_isSupported) {
      final currentIcon =
          await _flutterCustomIconChangerPlugin.getCurrentIcon();

      if (!mounted) return;

      setState(() {
        _currentIcon = CustomIcons.fromString(currentIcon);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Icon changer example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Spacer(),
              if (_isSupported)
                Text('currentIcon: $_currentIcon')
              else
                const Text('Changing the icon is not supported on this device'),
              const SizedBox(height: 32),
              _buildButton('Change first Icon', CustomIcons.first),
              const SizedBox(height: 8),
              _buildButton('Change second Icon', CustomIcons.second),
              const SizedBox(height: 8),
              _buildButton('Change default Icon', CustomIcons.byDefault),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, CustomIcons icon) {
    return ElevatedButton(
      onPressed: _isSupported ? () => _changeIcon(icon) : null,
      child: Text(title),
    );
  }

  Future<void> _changeIcon(CustomIcons icon) async {
    final currentIcon = icon.currentIcon;
    try {
      await _flutterCustomIconChangerPlugin.changeIcon(currentIcon);
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
  first('AppIcon1', 'MainActivityAlias1'),
  second('AppIcon2', 'MainActivityAlias2'),
  byDefault('AppIcon', 'MainActivity', isDefaultIcon: true);

  @override
  final String iOSIcon;
  @override
  final String androidIcon;
  @override
  final bool isDefaultIcon;

  const CustomIcons(
    this.iOSIcon,
    this.androidIcon, {
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
