package com.example.flutter_custom_icon_changer

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import kotlin.test.assertEquals
import org.mockito.Mockito.*

internal class FlutterCustomIconChangerPluginTest {

  @Test
  fun onMethodCall_isSupported_returnsExpectedValue() {
    val plugin = FlutterCustomIconChangerPlugin()

    val call = MethodCall("isSupported", null)
    val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    verify(mockResult).success(true)
  }

  @Test
  fun onMethodCall_getCurrentIcon_returnsExpectedValue() {
    val plugin = FlutterCustomIconChangerPlugin()

    val call = MethodCall("getCurrentIcon", null)
    val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    // Assuming the default icon is set
    val currentIcon = plugin.getCurrentIcon()
    verify(mockResult).success(currentIcon)
  }

  @Test
  fun onMethodCall_setAvailableIcons_setsIconsCorrectly() {
    val plugin = FlutterCustomIconChangerPlugin()

    val icons: List<Map<String, Any>> = listOf(
      mapOf("icon" to "icon1", "isDefaultIcon" to true),
      mapOf("icon" to "icon2", "isDefaultIcon" to false)
    )

    val call = MethodCall("setAvailableIcons", mapOf("icons" to icons))
    val mockResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    verify(mockResult).success(null)
    assertEquals(2, plugin.availableIcons.size)
    assertEquals("icon1", plugin.availableIcons[0].icon)
    assertEquals(true, plugin.availableIcons[0].isDefaultIcon)
    assertEquals("icon2", plugin.availableIcons[1].icon)
    assertEquals(false, plugin.availableIcons[1].isDefaultIcon)
  }

  @Test
  fun onMethodCall_changeIcon_changesIconCorrectly() {
    val plugin = FlutterCustomIconChangerPlugin()

    val icons: List<Map<String, Any>> = listOf(
      mapOf("icon" to "icon1", "isDefaultIcon" to true),
      mapOf("icon" to "icon2", "isDefaultIcon" to false)
    )

    // Set available icons first
    val setIconsCall = MethodCall("setAvailableIcons", mapOf("icons" to icons))
    val setIconsResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(setIconsCall, setIconsResult)

    // Change to a valid icon
    val changeIconCall = MethodCall("changeIcon", mapOf("iconName" to "icon2"))
    val changeIconResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(changeIconCall, changeIconResult)

    verify(changeIconResult).success(null)

    // Change to an invalid icon
    val invalidChangeIconCall = MethodCall("changeIcon", mapOf("iconName" to "invalidIcon"))
    val invalidChangeIconResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(invalidChangeIconCall, invalidChangeIconResult)

    verify(invalidChangeIconResult).error("iconNotFound", "Icon not found", null)

    // Change to null (default icon)
    val changeToNilIconCall = MethodCall("changeIcon", mapOf("iconName" to null))
    val changeToNilIconResult: MethodChannel.Result = mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(changeToNilIconCall, changeToNilIconResult)

    verify(changeToNilIconResult).success(null)
  }
}