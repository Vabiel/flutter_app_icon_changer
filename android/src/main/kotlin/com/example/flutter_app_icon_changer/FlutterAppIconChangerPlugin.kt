package com.example.flutter_app_icon_changer

import android.os.Build
import android.content.ComponentName
import android.content.pm.PackageManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAppIconChangerPlugin */
class FlutterAppIconChangerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var binding: FlutterPlugin.FlutterPluginBinding
  private val availableIcons = mutableListOf<AppIcon>()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_app_icon_changer")
    binding = flutterPluginBinding
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "changeIcon" -> {
        val iconName = call.argument<String>("iconName")
        changeIcon(iconName, result)
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
        val iconsList = call.argument<List<Map<String, Any>>>("icons")
        if (iconsList != null) {
          setAvailableIcons(iconsList)
          result.success(null)
        } else {
          result.error("INVALID_ARGS", "Arguments are invalid", null)
        }
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

  private fun changeIcon(iconName: String?, result: MethodChannel.Result) {
    val defaultIcon = availableIcons.firstOrNull { it.isDefaultIcon } ?: availableIcons.first()

    val iconToChange = if (iconName == null) {
      defaultIcon.icon
    } else {
      availableIcons.firstOrNull { it.icon == iconName }?.icon
    }

    if (iconToChange == null) {
      setIcon(defaultIcon.icon, result)
      result.error("ICON_NOT_FOUND", "Icon $iconName not found", null)
    } else {
      setIcon(iconToChange, result)
    }

  }

  private fun setIcon(icon: String, result: MethodChannel.Result) {
    val pm = binding.applicationContext.packageManager
    val packageName = binding.applicationContext.packageName

    availableIcons.filter {
      it.icon != icon
    }.forEach {
      disableComponent(pm, packageName, it.icon)
    }

    enableComponent(pm, packageName, icon)
    result.success(true)
  }

  private fun getCurrentIcon(): String? {
    val pm = binding.applicationContext.packageManager
    val packageName = binding.applicationContext.packageName

    for (appIcon in availableIcons) {
      if (isSelectedIcon(pm, packageName, appIcon.icon)) {
        return appIcon.icon
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

  private fun setAvailableIcons(iconsArray: List<Map<String, Any>>) {
    availableIcons.clear()
    for (iconMap in iconsArray) {
      val appIcon = AppIcon.fromMap(iconMap)
      if (appIcon != null) {
        availableIcons.add(appIcon)
      }
    }
  }
}

data class AppIcon(val icon: String, val isDefaultIcon: Boolean) {
  companion object {
    fun fromMap(map: Map<String, Any>): AppIcon? {
      val icon = map["icon"] as? String ?: return null
      val isDefaultIcon = map["isDefaultIcon"] as? Boolean ?: return null
      return AppIcon(icon, isDefaultIcon)
    }
  }
}
