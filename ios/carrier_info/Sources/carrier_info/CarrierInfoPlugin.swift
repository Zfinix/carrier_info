import Flutter
import UIKit

public class CarrierInfoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IosCarrierApiSetup.setUp(binaryMessenger: registrar.messenger(), api: Carrier())
    }
}
