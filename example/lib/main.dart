import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterCustomIconChangerPlugin = FlutterCustomIconChanger();

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
    final iconName = icon.iconName;
    try {
      await _flutterCustomIconChangerPlugin.changeIcon(iconName);
      setState(() {
        _currentIcon = icon;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to change icon: '${e.message}'.");
    }
  }
}

enum CustomIcons {
  first('AppIcon1', 'icon1'),
  second('AppIcon2', 'icon2'),
  byDefault(null, null);

  final String? _iosIconName;
  final String? _androidIconName;

  const CustomIcons(this._iosIconName, this._androidIconName);

  String? get iconName => Platform.isIOS ? _iosIconName : _androidIconName;

  factory CustomIcons.fromString(String? icon) {
    return CustomIcons.values.firstWhere(
      (e) => e._iosIconName == icon || e._androidIconName == icon,
      orElse: () => CustomIcons.byDefault,
    );
  }
}
