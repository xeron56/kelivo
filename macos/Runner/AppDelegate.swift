import Cocoa
import FlutterMacOS
import ServiceManagement

@main
class AppDelegate: FlutterAppDelegate {

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    setupCompanionChannel()
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      for window in sender.windows {
        window.makeKeyAndOrderFront(self)
      }
    }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // MARK: - Companion launch-at-login channel

  private func setupCompanionChannel() {
    guard let controller = mainFlutterWindow?.contentViewController as? FlutterViewController else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "app.companion.launch_at_login",
      binaryMessenger: controller.engine.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "setLaunchAtLogin":
        guard let args = call.arguments as? [String: Any],
              let enabled = args["enabled"] as? Bool else {
          result(FlutterError(code: "INVALID_ARGS", message: "enabled bool required", details: nil))
          return
        }
        self?.setLaunchAtLogin(enabled: enabled, result: result)
      case "getLaunchAtLogin":
        result(self?.isLaunchAtLoginEnabled() ?? false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func setLaunchAtLogin(enabled: Bool, result: @escaping FlutterResult) {
    if #available(macOS 13.0, *) {
      do {
        if enabled {
          try SMAppService.mainApp.register()
        } else {
          try SMAppService.mainApp.unregister()
        }
        result(nil)
      } catch {
        result(FlutterError(code: "SMAppService_ERROR", message: error.localizedDescription, details: nil))
      }
    } else {
      // Fallback for macOS 12 and earlier
      let success = SMLoginItemSetEnabled(Bundle.main.bundleIdentifier! as CFString, enabled)
      if success {
        result(nil)
      } else {
        result(FlutterError(code: "LOGIN_ITEM_FAILED", message: "Could not set login item", details: nil))
      }
    }
  }

  private func isLaunchAtLoginEnabled() -> Bool {
    if #available(macOS 13.0, *) {
      return SMAppService.mainApp.status == .enabled
    }
    return false
  }
}
