//
//  Carrier.swift
//  carrier_info
//
// From https://github.com/StanislavK/Carrier/blob/master/Carrier/Classes/Carrier.swift

import UIKit
import CoreTelephony

/// Wraps CTRadioAccessTechnologyDidChange notification
public protocol CarrierDelegate: class {
    func carrierRadioAccessTechnologyDidChange()
}

final public class Carrier {

    // MARK: - Private Properties
    private let networkInfo = CTTelephonyNetworkInfo()
    private let carrier: CTCarrier?
    private var changeObserver: NSObjectProtocol!

    public init() {
        self.carrier = networkInfo.subscriberCellularProvider

        changeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.CTRadioAccessTechnologyDidChange, object: nil, queue: nil) { [unowned self](notification) in
            DispatchQueue.main.async {
                self.delegate?.carrierRadioAccessTechnologyDidChange()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(changeObserver!)
        print(#function)
    }

    // MARK: - Public Properties
    public weak var delegate: CarrierDelegate?

    /// Returns the name of the user’s home cellular service provider.
    public var carrierName: String? {
        return carrier?.carrierName
    }

    /// Returns the ISO country code for the user’s cellular service provider.
    public var carrierIsoCountryCode: String? {
        return carrier?.isoCountryCode
    }

    /// Returns the mobile country code (MCC) for the user’s cellular service provider.
    public var carrierMobileCountryCode: String? {
        return carrier?.mobileCountryCode
    }

    /// Returns the mobile network code (MNC) for the user’s cellular service provider.
    public var carrierMobileNetworkCode: String? {
        return carrier?.mobileNetworkCode
    }

    /// Returns true/false if the carrier allows VoIP calls to be made on its network.
    public var carrierAllowsVOIP: Bool {
        return carrier?.allowsVOIP ?? false
    }

    /// Returns current radio access technology type used (GPRS, Edge, LTE, etc.) with the carrier.
    public var carrierRadioAccessTechnologyType: String? {
        let prefix = "CTRadioAccessTechnology"
        guard let currentTechnology = networkInfo.currentRadioAccessTechnology else {
            return nil
        }
        guard currentTechnology.hasPrefix(prefix) else {
            return currentTechnology
        }
        return String(currentTechnology.dropFirst(prefix.count))
    }

    /// Returns carrier network generation based on radio accesss technology type.
    public var carrierNetworkGeneration: String? {

        enum ShortRadioAccessTechnologyList: String {
            case gprs = "GPRS"
            case edge = "Edge"
            case cdma = "CDMA1x"
            case lte  = "LTE"

            var generation: String {
                switch self {
                case .gprs, .edge, .cdma: return "2G"
                case .lte: return "4G"
                }
            }
        }

        if let radioType = carrierRadioAccessTechnologyType {
            let generation = ShortRadioAccessTechnologyList(rawValue: radioType)?.generation ?? "3G"
            return generation

        } else {
            return nil
        }
    }

    /// Returns all available info about the carrier.
    public var carrierInfo: [String: Any?] {
        return [
            "carrierName": carrierName,
            "carrierIsoCountryCode": carrierIsoCountryCode,
            "carrierMobileCountryCode": carrierMobileCountryCode,
            "carrierMobileNetworkCode": carrierMobileNetworkCode,
            "carrierAllowsVOIP": carrierAllowsVOIP,
            "carrierRadioAccessTechnologyType": carrierRadioAccessTechnologyType,
            "carrierNetworkGeneration": carrierNetworkGeneration,
        ]
    }
}
