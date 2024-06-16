package com.example.flutter_custom_icon_changer

import androidx.annotation.NonNull
import android.os.Build
import android.content.ComponentName
import android.content.pm.PackageManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterCustomIconChangerPlugin */
class FlutterCustomIconChangerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var binding: FlutterPlugin.FlutterPluginBinding
  private var availableIcons: List<String> = listOf()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_custom_icon_changer")
    binding = flutterPluginBinding
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "changeIcon" -> {
        val iconName = call.argument<String>("iconName")
        changeIcon(iconName)
        result.success(true)
      }
      "getCurrentIcon" -> {
        val currentIcon = getCurrentIcon()
        result.success(currentIcon)
      }
      "isSupported" -> {
        val isSupported = isSupported()
        result.success(isSupported)
      }
      "setAvailableIcons" -> {
        val icons = call.argument<List<String>>("icons")
        setAvailableIcons(icons)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun disableComponent(packageManager: PackageManager, packageName: String, icon: String) {
    val activityName = "$packageName.$icon"
    packageManager.setComponentEnabledSetting(
      ComponentName(packageName, activityName),
      PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
      PackageManager.DONT_KILL_APP
    )
  }

  private fun enableComponent(packageManager: PackageManager, packageName: String, icon: String) {
    val activityName = "$packageName.$icon"
    packageManager.setComponentEnabledSetting(
      ComponentName(packageName, activityName),
      PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
      PackageManager.DONT_KILL_APP
    )
  }

  private fun changeIcon(iconName: String?) {
    val defaultIconName = "MainActivity"
    val pm = binding.applicationContext.packageManager
    val packageName = binding.applicationContext.packageName

    val icon = iconName ?: defaultIconName

    availableIcons.filter {
      it != icon
    }.forEach {
      disableComponent(pm, packageName, it)
    }

    enableComponent(pm, packageName, icon)
  }

  private fun getCurrentIcon(): String? {
    val pm = binding.applicationContext.packageManager
    val packageName = binding.applicationContext.packageName

    for (icon in availableIcons) {
      if (isSelectedIcon(pm, packageName, icon)) {
        return icon
      }
    }

    return null
  }

  private fun isSelectedIcon(packageManager: PackageManager, packageName: String, icon: String): Boolean {
    val activityName = "$packageName.$icon"
    return  packageManager.getComponentEnabledSetting(ComponentName(packageName, activityName)) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED
  }

  private fun isSupported(): Boolean {
    return Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP
  }

  private fun setAvailableIcons(icons: List<String>?) {
    if (icons != null) {
      availableIcons = icons
    }
  }
}
