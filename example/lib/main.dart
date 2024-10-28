import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';
import 'package:flutter_app_icon_changer_example/src/models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterAppIconChangerPlugin = FlutterAppIconChangerPlugin(
    iconsSet: CustomIconsSet(),
  );

  CustomIcon _currentIcon = CustomIcons.defaultIcon;
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
        _currentIcon = CustomIcon.fromString(currentIcon);
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
        body: Column(
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
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIcon(CustomIcons.redIcon),
                      const SizedBox(width: 8),
                      _buildIcon(CustomIcons.purpleIcon),
                      const SizedBox(width: 8),
                      _buildIcon(CustomIcons.defaultIcon),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(CustomIcon icon) {
    final border = BorderRadius.circular(8.0);

    return InkWell(
      borderRadius: border,
      onTap: _isSupported ? () => _changeIcon(icon) : null,
      child: Card(
        shape: icon == _currentIcon ? _buildBorder(border) : null,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
        width: 4.0,
      ),
    );
  }

  Widget _buildPreviewIcon(CustomIcon icon, {double size = 100}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        icon.previewPath,
        fit: BoxFit.contain,
        width: size,
        height: size,
      ),
    );
  }

  Future<void> _changeIcon(CustomIcon icon) async {
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
