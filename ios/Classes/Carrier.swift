//
//  Carrier.swift
//  carrier_info
//
// From https://github.com/StanislavK/Carrier/blob/master/Carrier/Classes/Carrier.swift

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
        
        changeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.CTRadioAccessTechnologyDidChange, object: nil, queue: nil) { [unowned self](notification) in
            DispatchQueue.main.async {
                self.delegate?.carrierRadioAccessTechnologyDidChange()
            }
        }
        
        if #available(iOS 12.0, *) {
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
                    
                }else{
                    
                    technologyList.append(ShortRadioAccessTechnologyList(rawValue: technology)?.generation ?? "3G")
                    
                }
                
            }
            
        }
        
        return technologyList
        
    }
    
    
    /// Returns all available info about the carrier.
    public var carrierInfo: [String: Any?] {
        
        var dataList =  [[String: Any?]]()
        
        for carr in carriers.values {
            dataList.append([
                "carrierName": carr.carrierName,
                "isoCountryCode": carr.isoCountryCode,
                "mobileCountryCode": carr.mobileCountryCode,
                "mobileNetworkCode": carr.mobileNetworkCode,
                "carrierAllowsVOIP": carr.allowsVOIP,
            ])
            
        }
        
       if #available(iOS 16.0, *) {
            return [
                "carrierData": dataList,
                "carrierRadioAccessTechnologyTypeList": carrierRadioAccessTechnologyTypeList,
                "supportsEmbeddedSIM": planProvisioning.supportsEmbeddedSIM,
                "serviceCurrentRadioAccessTechnology": networkInfo.serviceCurrentRadioAccessTechnology,
            ]
        }else {
            return [
                "carrierData": dataList,
                "carrierRadioAccessTechnologyTypeList": carrierRadioAccessTechnologyTypeList,
                "serviceCurrentRadioAccessTechnology": networkInfo.serviceCurrentRadioAccessTechnology,
            ]
        }
    }
}
