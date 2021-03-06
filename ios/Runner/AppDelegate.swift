import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var mainCoordinator: AppCoordinator?
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
    
        GeneratedPluginRegistrant.register(with: self)

        // create and configure the channel
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        let passChannel = FlutterMethodChannel(name: "com.jumpstart.hkard/pass",
                                              binaryMessenger: flutterViewController.binaryMessenger)

        passChannel.setMethodCallHandler{
            (call, result) in
            self.handle(call, result)
        }

        GeneratedPluginRegistrant.register(with: self)
        let navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        mainCoordinator = AppCoordinator(navigationController: navigationController)
        window?.makeKeyAndVisible()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func handle(_ call: FlutterMethodCall, _ result: FlutterResult) {
        switch call.method {
        case "createPassWithURL":
            let args: NSDictionary = call.arguments as! NSDictionary
            guard let passURL = args["passURL"] as? String else {
                return
            }
            
            print(passURL)
            self.mainCoordinator?.start()
            self.mainCoordinator?.downloadAndSetPassWithURL(url: passURL)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
