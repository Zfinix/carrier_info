//
//  Carrier.swift
//  carrier_info
//
// From https://github.com/StanislavK/Carrier/blob/master/Carrier/Classes/Carrier.swift
//
// IMPORTANT: CTCarrier is deprecated starting iOS 16.0
// This implementation provides fallback values for iOS 16.0+ to maintain compatibility
// but carrier-specific information will be limited or unavailable on newer iOS versions.

import UIKit
import CoreTelephony

enum ShortRadioAccessTechnologyList: String {
    case gprs = "GPRS"
    case edge = "Edge"
    case cdma = "CDMA1x"
    case lte  = "LTE"
    case nrnsa = "NRNSA"
    case nr = "NR"
    
    var generation: String {
        switch self {
        case .gprs, .edge, .cdma: return "2G"
        case .lte: return "4G"
        case .nrnsa, .nr: return "5G"
        }
    }
}

/// Wraps CTRadioAccessTechnologyDidChange notification
public protocol CarrierDelegate: AnyObject {
    func carrierRadioAccessTechnologyDidChange()
}

@available(iOS 12.0, *)
final public class Carrier {
    
    // MARK: - Private Properties
    private let networkInfo = CTTelephonyNetworkInfo()
    private let planProvisioning = CTCellularPlanProvisioning()
    private var carriers = [String : CTCarrier]()
    private var changeObserver: NSObjectProtocol!
    
    public init() {
        
        changeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.CTServiceRadioAccessTechnologyDidChange, object: nil, queue: nil) { [unowned self](notification) in
            DispatchQueue.main.async {
                self.delegate?.carrierRadioAccessTechnologyDidChange()
            }
        }
        
        // Handle CTCarrier deprecation in iOS 16.0+
        if #available(iOS 16.0, *) {
            // CTCarrier is deprecated in iOS 16.0+
            // serviceSubscriberCellularProviders returns nil or empty data
            // We'll provide fallback empty data structure
            self.carriers = [:]
            print("⚠️ CTCarrier is deprecated in iOS 16.0+. Carrier information will be limited.")
        } else if #available(iOS 12.0, *) {
            self.carriers = networkInfo.serviceSubscriberCellularProviders ?? [:]
        } else {
            if(networkInfo.subscriberCellularProvider != nil){
                carriers = ["0": networkInfo.subscriberCellularProvider!]
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(changeObserver!)
    }
    
    public weak var delegate: CarrierDelegate?
    
    /// Returns current radio access technology type used (GPRS, Edge, LTE, etc.) with the carrier.
    /// This functionality is still available in iOS 16.0+ as it doesn't rely on CTCarrier.
    public var carrierRadioAccessTechnologyTypeList: [String?] {
        var technologyList  =  [String]()
        
        if #available(iOS 12.0, *) {
            let prefix = "CTRadioAccessTechnology"
            guard let currentTechnologies = networkInfo.serviceCurrentRadioAccessTechnology else {
                return []
            }
            
            for technology in currentTechnologies.values {
                if technology.hasPrefix(prefix) {
                    technologyList.append(String(technology.dropFirst(prefix.count)))
                } else {
                    technologyList.append(ShortRadioAccessTechnologyList(rawValue: technology)?.generation ?? "3G")
                }
            }
        }
        
        return technologyList
    }
    
    /// Detects if any SIM card is inserted and active
    public var isSIMInserted: Bool {
        if #available(iOS 16.0, *) {
            // On iOS 16.0+, check if we have any current radio access technology
            // This indicates active cellular service
            return !(networkInfo.serviceCurrentRadioAccessTechnology?.isEmpty ?? true)
        } else {
            // Pre-iOS 16.0, check if we have any carriers
            return !carriers.isEmpty
        }
    }
    
    /// Returns subscriber information including carrier tokens
    public var subscriberInfo: [String: Any?] {
        var info: [String: Any?] = [:]
        
        if #available(iOS 16.0, *) {
            // Use CTSubscriberInfo for iOS 16.0+
            let subscribers = CTSubscriberInfo.subscribers()
            info["subscriberCount"] = subscribers.count
            info["subscriberIdentifiers"] = subscribers.compactMap { $0.identifier }
            
            // Add carrier tokens if available
            var carrierTokens: [String] = []
            for subscriber in subscribers {
                if let carrierToken = subscriber.carrierToken {
                    carrierTokens.append(carrierToken.base64EncodedString())
                }
            }
            info["carrierTokens"] = carrierTokens.isEmpty ? nil : carrierTokens
        } else {
            // Legacy CTSubscriber for older iOS versions
            let subscriber = CTSubscriber()
            info["subscriberCount"] = 1
            
            // Handle subscriber identifier
            let subscriberId = subscriber.identifier
            info["subscriberIdentifiers"] = [subscriberId]
            
            // Add carrier token if available
            if let carrierToken = subscriber.carrierToken {
                info["carrierTokens"] = [carrierToken.base64EncodedString()]
            } else {
                info["carrierTokens"] = nil
            }
        }
        
        return info
    }
    
    /// Returns cellular plan provisioning information
    public var cellularPlanInfo: [String: Any?] {
        var planInfo: [String: Any?] = [:]
        
        if #available(iOS 16.0, *) {
            planInfo["supportsEmbeddedSIM"] = planProvisioning.supportsEmbeddedSIM
        } else {
            planInfo["supportsEmbeddedSIM"] = false
        }
        
        return planInfo
    }
    
    /// Returns network connectivity status
    public var networkStatus: [String: Any?] {
        var status: [String: Any?] = [:]
        
        // Check if cellular data is available
        status["hasCellularData"] = networkInfo.serviceCurrentRadioAccessTechnology != nil
        
        // Get current radio access technologies
        if let currentTechs = networkInfo.serviceCurrentRadioAccessTechnology {
            status["activeServices"] = currentTechs.keys.count
            status["technologies"] = Array(currentTechs.values)
        } else {
            status["activeServices"] = 0
            status["technologies"] = []
        }
        
        return status
    }
    
    /// Returns all available info about the carrier.
    /// Note: Starting iOS 16.0, CTCarrier is deprecated and most carrier-specific
    /// information will return nil or generic values.
    public var carrierInfo: [String: Any?] {
        
        var dataList =  [[String: Any?]]()
        let subscriberId: String?
        
        // Handle CTSubscriber deprecation and availability
        if #available(iOS 16.0, *) {
            // CTSubscriber().identifier is also deprecated in iOS 16.0+
            subscriberId = nil
        } else {
            subscriberId = CTSubscriber().identifier
        }
        
        // Handle carrier data based on iOS version
        if #available(iOS 16.0, *) {
            // CTCarrier is deprecated - provide fallback structure
            dataList.append([
                "carrierName": nil,
                "isoCountryCode": nil,
                "mobileCountryCode": nil,
                "mobileNetworkCode": nil,
                "carrierAllowsVOIP": nil,
                "_deprecated_notice": "CTCarrier is deprecated in iOS 16.0+. Carrier information is no longer available."
            ])
        } else {
            // Pre-iOS 16.0 - use actual carrier data
            for carr in carriers.values {
                dataList.append([
                    "carrierName": carr.carrierName,
                    "isoCountryCode": carr.isoCountryCode,
                    "mobileCountryCode": carr.mobileCountryCode,
                    "mobileNetworkCode": carr.mobileNetworkCode,
                    "carrierAllowsVOIP": carr.allowsVOIP,
                ])
            }
        }
        
        // Convert NSOperatingSystemVersion to dictionary for Flutter method channel
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let osVersionDict: [String: Any] = [
            "majorVersion": osVersion.majorVersion,
            "minorVersion": osVersion.minorVersion,
            "patchVersion": osVersion.patchVersion
        ]
        
        // Build comprehensive response
        var response: [String: Any?] = [
            "carrierData": dataList,
            "carrierRadioAccessTechnologyTypeList": carrierRadioAccessTechnologyTypeList,
            "subscriberIdentifier": subscriberId,
            "serviceCurrentRadioAccessTechnology": networkInfo.serviceCurrentRadioAccessTechnology,
            "isSIMInserted": isSIMInserted,
            "subscriberInfo": subscriberInfo,
            "cellularPlanInfo": cellularPlanInfo,
            "networkStatus": networkStatus,
            "_ios_version_info": [
                "ios_version": osVersionDict,
                "ctcarrier_deprecated": osVersion.majorVersion >= 16,
                "deprecation_notice": osVersion.majorVersion >= 16 ? 
                    "CTCarrier and CTSubscriber are deprecated in iOS 16.0+. Most carrier-specific information is no longer available for privacy and security reasons." :
                    "CTCarrier functionality is available on this iOS version."
            ]
        ]
        
        // Add iOS 16.0+ specific information
        if #available(iOS 16.0, *) {
            response["subscriberIdentifier2"] = CTSubscriberInfo.subscribers().map{$0.identifier}
        }
        
        return response
    }
}
