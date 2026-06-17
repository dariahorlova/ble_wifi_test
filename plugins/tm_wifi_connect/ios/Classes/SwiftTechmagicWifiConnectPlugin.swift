import Flutter
import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

public class SwiftTechmagicWifiConnectPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tm_wifi_connect", binaryMessenger: registrar.messenger())
    let instance = SwiftTechmagicWifiConnectPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
      switch (call.method) {
        case "isWifiEnabled":
          result(isWifiEnabled())
          return

        case "activateWifi":
          setWifiState(target: true, result: result)
          return

        case "deactivateWifi":
          setWifiState(target: false, result: result)
          return

        case "disconnect":
          result(disconnect())
          return

        case "getSSID":
          result(getSSID())
          return

        case "connect":
          let args = try GetArgs(arguments: call.arguments)
          let hotspotConfig = NEHotspotConfiguration.init(ssid: args["ssid"] as! String)
          hotspotConfig.joinOnce = !(args["saveNetwork"] as! Bool);
          connect(hotspotConfig: hotspotConfig, result: result)
          return

        case "prefixConnect":
          guard #available(iOS 13.0, *) else {
            result(FlutterError(code: "iOS must be above 13", message: "Prefix connect doesn't work on iOS pre 13", details: nil))
            return
          }
          let args = try GetArgs(arguments: call.arguments)
          let hotspotConfig = NEHotspotConfiguration.init(ssidPrefix: args["ssid"] as! String)
          hotspotConfig.joinOnce = !(args["saveNetwork"] as! Bool);
          connect(hotspotConfig: hotspotConfig, result: result)
          return

        case "secureConnect":
          let args = try GetArgs(arguments: call.arguments)
          let hotspotConfig = NEHotspotConfiguration.init(ssid: args["ssid"] as! String, passphrase: args["password"] as! String, isWEP: args["isWep"] as! Bool)
          hotspotConfig.joinOnce = !(args["saveNetwork"] as! Bool);
          connect(hotspotConfig: hotspotConfig, result: result)
          return

        case "securePrefixConnect":
          guard #available(iOS 13.0, *) else {
            result(FlutterError(code: "iOS must be above 13", message: "Prefix connect doesn't work on iOS pre 13", details: nil))
            return
          }
          let args = try GetArgs(arguments: call.arguments)
          let hotspotConfig = NEHotspotConfiguration.init(ssidPrefix: args["ssid"] as! String, passphrase: args["password"] as! String, isWEP: args["isWep"] as! Bool)
          hotspotConfig.joinOnce = !(args["saveNetwork"] as! Bool);
          connect(hotspotConfig: hotspotConfig, result: result)
          return

        default:
          result(FlutterMethodNotImplemented)
          return
      }
    } catch ArgsError.MissingArgs {
        result(
          FlutterError( code: "missingArgs",
            message: "Missing args",
            details: "Missing args."))
        return
    } catch {
        result(
          FlutterError( code: "unknownError",
            message: "Unkown iOS error",
            details: error))
        return
    }
  }

  enum ArgsError: Error {
    case MissingArgs
  }

  func GetArgs(arguments: Any?) throws -> [String : Any]{
    guard let args = arguments as? [String : Any] else {
      throw ArgsError.MissingArgs
    }
    return args
  }

  // MARK: - WiFi radio state

  /// Best-effort detection of the WiFi radio state. iOS exposes no public API
  /// for this, so we inspect the `awdl0` (Apple Wireless Direct Link)
  /// interface, which is brought up only while WiFi is enabled.
  private func isWifiEnabled() -> Bool {
    var enabled = false
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else {
      return false
    }
    var ptr = ifaddr
    while ptr != nil {
      defer { ptr = ptr?.pointee.ifa_next }
      guard let interface = ptr?.pointee else { continue }
      let name = String(cString: interface.ifa_name)
      if name == "awdl0" {
        let flags = Int32(interface.ifa_flags)
        if (flags & IFF_UP) == IFF_UP {
          enabled = true
          break
        }
      }
    }
    freeifaddrs(ifaddr)
    return enabled
  }

  /// Brings the WiFi radio to [target] state. iOS cannot toggle it
  /// programmatically, so we send the user to the system WiFi settings and
  /// then poll `isWifiEnabled` every 0.5s for up to 30s, replying true once the
  /// target state is reached or false on timeout.
  private func setWifiState(target: Bool, result: @escaping FlutterResult) {
    if isWifiEnabled() == target {
      result(true)
      return
    }

    if let url = URL(string: "App-Prefs:root=WIFI") {
      DispatchQueue.main.async {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }

    pollWifiState(target: target, ticks: 0, result: result)
  }

  /// Polls `isWifiEnabled` twice per second. Recursion guarantees a single
  /// reply: it resolves on the first matching tick or after 60 ticks (30s).
  private func pollWifiState(target: Bool, ticks: Int, result: @escaping FlutterResult) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      guard let self = self else {
        result(false)
        return
      }
      if self.isWifiEnabled() == target {
        result(true)
        return
      }
      if ticks + 1 >= 60 {
        result(false)
        return
      }
      self.pollWifiState(target: target, ticks: ticks + 1, result: result)
    }
  }

  // MARK: - Connect / disconnect

  @available(iOS 11, *)
  private func connect(hotspotConfig: NEHotspotConfiguration, result: @escaping FlutterResult) -> Void {
    NEHotspotConfigurationManager.shared.apply(hotspotConfig) { (error) in
      if let error = error as NSError? {
        switch(error.code) {
        case NEHotspotConfigurationError.alreadyAssociated.rawValue:
            NSLog("[tm_wifi_connect] apply: alreadyAssociated -> success")
            result(true)
        case NEHotspotConfigurationError.userDenied.rawValue:
            NSLog("[tm_wifi_connect] apply: userDenied")
            result(false)
        default:
            NSLog("[tm_wifi_connect] apply failed: code=\(error.code) \(error.localizedDescription)")
            result(false)
        }
        return
      }
      // apply() succeeded with no error. Trust it: do NOT re-verify the SSID
      // here. On iOS 17+/18+ NEHotspotNetwork.fetchCurrent / CNCopyCurrentNetworkInfo
      // can return nil, the previous SSID, or a redacted value right after apply,
      // which would falsely report failure. The caller is expected to verify true
      // reachability via the app-level network check (e.g. socket to the device).
      result(true)
    }
  }

  @available(iOS 11, *)
  private func disconnect() -> Bool {
    let ssid: String? = getSSID()
    if(ssid == nil){
      return false
    }
    NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: ssid ?? "")
    return true
  }

  private func getSSID() -> String? {
    var ssid: String?
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
      for interface in interfaces {
        if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
          ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
          break
        }
      }
    }
    return ssid
  }
}
