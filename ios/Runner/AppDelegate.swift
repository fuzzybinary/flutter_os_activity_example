import UIKit
import Flutter
import os.activity

class ActivityReference {
  var activity: os_activity_t?
  var activityState = os_activity_scope_state_s()

}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var methodChannel: FlutterMethodChannel!
  var activityMap: [String: ActivityReference] = [:]

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let osPlugin = registrar(forPlugin: "OsActivityHelper")!
    registerOsPlugin(with: osPlugin)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc func registerOsPlugin(with registrar: FlutterPluginRegistrar) {
    methodChannel = FlutterMethodChannel(name: "org.example.os_activity", binaryMessenger: registrar.messenger())
    methodChannel.setMethodCallHandler({ call, result in
      self.handle(methodCall: call, result: result)
    })
  }

  func handle(methodCall: FlutterMethodCall, result: FlutterResult) {
    switch methodCall.method {
    case "createActivity":
      let activityRef = ActivityReference()

      activityRef.activity = CreateActivity()
      let activityIdInt = os_activity_get_identifier(activityRef.activity!, nil)

      let activityIdString = String(activityIdInt)
      activityMap[activityIdString] = activityRef

      result(activityIdString)

    case "enterScope":
      let args = methodCall.arguments as! [String:Any?]
      if let activityId = args["activityId"] as? String,
         let activityRef = activityMap[activityId] {
        os_activity_scope_enter(activityRef.activity!, &activityRef.activityState)
      }
      result(nil)

    case "getCurrentActivity":
      var parentIdent: os_activity_id_t = 0
      let activityIdent = os_activity_get_identifier(CurrentActivity(), &parentIdent)

      result([String(activityIdent), String(parentIdent)])

    case "leaveScope":
      let args = methodCall.arguments as! [String:Any?]
      if let activityId = args["activityId"] as? String,
         let activityRef = activityMap[activityId] {
        os_activity_scope_leave(&activityRef.activityState)
      }
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
