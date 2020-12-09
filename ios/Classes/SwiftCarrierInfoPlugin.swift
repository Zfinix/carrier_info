import Flutter
import UIKit

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
            
            case "carrierName":
                self.carrierName(result: result)

            case "allowsVOIP":
                self.allowsVOIP(result: result)
                
            case "isoCountryCode":
                self.isoCountryCode(result: result)
                
            case "mobileCountryCode":
                self.mobileCountryCode(result: result)
                
            case "mobileNetworkCode":
                self.mobileNetworkCode(result: result)
                
            case "mobileNetworkOperator":
                self.mobileNetworkOperator(result: result)
            
            case "radioType":
                self.radioType(result: result)
            
            case "networkGeneration":
                self.networkGeneration(result: result)
                
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }
    
    public func carrierName(result: @escaping FlutterResult){
        result(carrier.carrierName)
    }
    public func allowsVOIP(result: @escaping FlutterResult){
        result(carrier.carrierAllowsVOIP)
    }
    
    public func isoCountryCode(result: @escaping FlutterResult){
        result(carrier.carrierIsoCountryCode)
    }
    
    public func mobileCountryCode(result: @escaping FlutterResult){
        result(carrier.carrierMobileCountryCode)
    }
    
    public func mobileNetworkCode(result: @escaping FlutterResult){
        result(carrier.carrierMobileNetworkCode)
    }
    
    public func mobileNetworkOperator(result: @escaping FlutterResult){
        result("")
    }
    
    public func radioType(result: @escaping FlutterResult){
        result(carrier.carrierRadioAccessTechnologyType)
    }
    
    public func networkGeneration(result: @escaping FlutterResult){
        result(carrier.carrierNetworkGeneration)
    }
}
