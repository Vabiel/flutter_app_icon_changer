import Flutter
import UIKit
import XCTest

@testable import flutter_custom_icon_changer

class RunnerTests: XCTestCase {

    func testIsSupported() {
        let plugin = FlutterCustomIconChangerPlugin()

        let call = FlutterMethodCall(methodName: "isSupported", arguments: nil)

        let resultExpectation = expectation(description: "result block must be called.")
        plugin.handle(call) { result in
            XCTAssertEqual(result as! Bool, UIApplication.shared.supportsAlternateIcons)
            resultExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testGetCurrentIcon() {
        let plugin = FlutterCustomIconChangerPlugin()

        // Assuming the default icon is set
        let call = FlutterMethodCall(methodName: "getCurrentIcon", arguments: nil)

        let resultExpectation = expectation(description: "result block must be called.")
        plugin.handle(call) { result in
            if let alternateIconName = UIApplication.shared.alternateIconName {
                XCTAssertEqual(result as? String, alternateIconName)
            } else {
                XCTAssertNil(result as? String)
            }
            resultExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testSetAvailableIcons() {
        let plugin = FlutterCustomIconChangerPlugin()
        let icons: [[String: Any]] = [
            ["icon": "icon1", "isDefaultIcon": true],
            ["icon": "icon2", "isDefaultIcon": false]
        ]

        let call = FlutterMethodCall(methodName: "setAvailableIcons", arguments: ["icons": icons])

        let resultExpectation = expectation(description: "result block must be called.")
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(plugin.availableIcons.count, 2)
            XCTAssertEqual(plugin.availableIcons[0].icon, "icon1")
            XCTAssertEqual(plugin.availableIcons[0].isDefaultIcon, true)
            XCTAssertEqual(plugin.availableIcons[1].icon, "icon2")
            XCTAssertEqual(plugin.availableIcons[1].isDefaultIcon, false)
            resultExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testChangeIcon() {
        let plugin = FlutterCustomIconChangerPlugin()
        let icons: [[String: Any]] = [
            ["icon": "icon1", "isDefaultIcon": true],
            ["icon": "icon2", "isDefaultIcon": false]
        ]

        // Set available icons first
        let setIconsCall = FlutterMethodCall(methodName: "setAvailableIcons", arguments: ["icons": icons])
        let setIconsExpectation = expectation(description: "setAvailableIcons must be called.")
        plugin.handle(setIconsCall) { result in
            XCTAssertNil(result)
            setIconsExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        // Change to a valid icon
        let changeIconCall = FlutterMethodCall(methodName: "changeIcon", arguments: ["iconName": "icon2"])
        let changeIconExpectation = expectation(description: "changeIcon must be called.")
        plugin.handle(changeIconCall) { result in
            XCTAssertNil(result)
            XCTAssertEqual(UIApplication.shared.alternateIconName, "icon2")
            changeIconExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        // Change to an invalid icon
        let invalidChangeIconCall = FlutterMethodCall(methodName: "changeIcon", arguments: ["iconName": "invalidIcon"])
        let invalidChangeIconExpectation = expectation(description: "invalid changeIcon must be called.")
        plugin.handle(invalidChangeIconCall) { result in
            XCTAssertNotNil(result as? FlutterError)
            XCTAssertEqual((result as? FlutterError)?.code, "iconNotFound")
            XCTAssertEqual(UIApplication.shared.alternateIconName, "icon1") // Should fallback to default icon
            invalidChangeIconExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        // Change to nil (default icon)
        let changeToNilIconCall = FlutterMethodCall(methodName: "changeIcon", arguments: ["iconName": NSNull()])
        let changeToNilIconExpectation = expectation(description: "changeIcon to nil must be called.")
        plugin.handle(changeToNilIconCall) { result in
            XCTAssertNil(result)
            XCTAssertNil(UIApplication.shared.alternateIconName) // Default icon should be nil
            changeToNilIconExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
