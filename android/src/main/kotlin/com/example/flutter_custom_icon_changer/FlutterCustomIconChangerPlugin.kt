package com.example.flutter_custom_icon_changer

import androidx.annotation.NonNull
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

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_custom_icon_changer")
    binding = flutterPluginBinding
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "changeIcon" -> {
        val iconName = call.argument<String>("iconName")
        changeIcon(iconName)
        result.success(true)
      }
      "getCurrentIcon" -> {
        val currentIcon = getCurrentIcon()
        result.success(currentIcon)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  // TODO: Need refactoring and optimization!!!
  private fun changeIcon(iconName: String?) {
    val pm = binding.applicationContext.packageManager
    val packageName = binding.applicationContext.packageName

    val mainActivity = "$packageName.MainActivity"
    val alias1 = "$packageName.MainActivityAlias1"
    val alias2 = "$packageName.MainActivityAlias2"

    pm.setComponentEnabledSetting(
      ComponentName(packageName, mainActivity),
      PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
      PackageManager.DONT_KILL_APP
    )

    pm.setComponentEnabledSetting(
      ComponentName(packageName, alias1),
      PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
      PackageManager.DONT_KILL_APP
    )

    pm.setComponentEnabledSetting(
      ComponentName(packageName, alias2),
      PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
      PackageManager.DONT_KILL_APP
    )

    when (iconName) {
      "icon1" -> pm.setComponentEnabledSetting(
        ComponentName(packageName, alias1),
        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
        PackageManager.DONT_KILL_APP
      )
      "icon2" -> pm.setComponentEnabledSetting(
        ComponentName(packageName, alias2),
        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
        PackageManager.DONT_KILL_APP
      )
      else -> pm.setComponentEnabledSetting(
        ComponentName(packageName, mainActivity),
        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
        PackageManager.DONT_KILL_APP
      )
    }
  }

  // TODO: Need refactoring and optimization!!!
  private fun getCurrentIcon(): String? {
    val pm = binding.applicationContext.packageManager
    val packageName = binding.applicationContext.packageName

    val mainActivity = "$packageName.MainActivity"
    val alias1 = "$packageName.MainActivityAlias1"
    val alias2 = "$packageName.MainActivityAlias2"

    if (pm.getComponentEnabledSetting(ComponentName(packageName, alias1)) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
      return "icon1"
    } else if (pm.getComponentEnabledSetting(ComponentName(packageName, alias2)) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
      return "icon2"
    } else if (pm.getComponentEnabledSetting(ComponentName(packageName, mainActivity)) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
      return null
    }

    return null
  }
}
