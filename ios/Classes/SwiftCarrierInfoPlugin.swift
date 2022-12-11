import Flutter
import UIKit

@available(iOS 12.0, *)
public class SwiftCarrierInfoPlugin: NSObject, FlutterPlugin {
    fileprivate let carrier = Carrier()
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.chizi.tech/carrier_info", binaryMessenger: registrar.messenger())
        let instance = SwiftCarrierInfoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.main.async { [self] in
            switch call.method {
            
            case "getIosInfo":
                result(carrier.carrierInfo)
                
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }

}
