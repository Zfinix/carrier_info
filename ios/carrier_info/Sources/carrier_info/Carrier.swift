//
//  Carrier.swift
//  carrier_info
//
// Based on https://github.com/StanislavK/Carrier/blob/master/Carrier/Classes/Carrier.swift

import CoreTelephony
import Foundation
import Network

private let firstValueTimeout: TimeInterval = 0.5

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

/// Resumes a continuation once, whichever of the value or the timeout arrives first.
private final class OnceContinuation<T>: @unchecked Sendable {
    private let lock = NSLock()
    private var continuation: CheckedContinuation<T, Never>?

    init(_ continuation: CheckedContinuation<T, Never>) {
        self.continuation = continuation
    }

    func resume(_ value: T) {
        lock.lock()
        let pending = continuation
        continuation = nil
        lock.unlock()
        pending?.resume(returning: value)
    }
}

final class Carrier: IosCarrierApi {
    private let networkInfo = CTTelephonyNetworkInfo()
    private let planProvisioning = CTCellularPlanProvisioning()
    private let cellularData = CTCellularData()

    func getIosInfo() async throws -> IosCarrierMessage {
        let path = await currentPath()
        let currentTechnologies = networkInfo.serviceCurrentRadioAccessTechnology

        return IosCarrierMessage(
            carrierData: carrierData,
            carrierRadioAccessTechnologyTypeList: radioAccessTechnologies(
                currentTechnologies,
                dataService: networkInfo.dataServiceIdentifier
            ),
            isSIMInserted: isSIMInserted(currentTechnologies),
            supportsEmbeddedSIM: supportsEmbeddedSIM,
            subscriberInfo: subscriberInfo,
            networkStatus: IosNetworkStatusMessage(
                hasCellularData: currentTechnologies != nil,
                activeServices: Int64(currentTechnologies?.count ?? 0),
                technologies: currentTechnologies.map { Array($0.values) } ?? [],
                isExpensive: path?.isExpensive,
                isConstrained: path?.isConstrained,
                usesCellular: path?.usesInterfaceType(.cellular)
            ),
            dataServiceIdentifier: networkInfo.dataServiceIdentifier,
            cellularDataRestriction: await cellularDataRestriction()
        )
    }

    private var supportsEmbeddedSIM: Bool {
        if #available(iOS 16.0, *) {
            return planProvisioning.supportsEmbeddedSIM
        }
        return planProvisioning.supportsCellularPlan()
    }

    /// CTCarrier is deprecated from iOS 16 and returns placeholder values, so one empty entry is reported instead.
    private var carrierData: [IosCarrierEntryMessage] {
        if #available(iOS 16.0, *) {
            return [IosCarrierEntryMessage()]
        }
        return (networkInfo.serviceSubscriberCellularProviders ?? [:]).values.map { carrier in
            IosCarrierEntryMessage(
                mobileNetworkCode: carrier.mobileNetworkCode,
                carrierAllowsVOIP: carrier.allowsVOIP,
                mobileCountryCode: carrier.mobileCountryCode,
                carrierName: carrier.carrierName,
                isoCountryCode: carrier.isoCountryCode
            )
        }
    }

    /// Lists the data service first, so the summary reports the network carrying mobile data.
    private func radioAccessTechnologies(_ technologies: [String: String]?, dataService: String?) -> [String] {
        let prefix = "CTRadioAccessTechnology"
        let ordered = (technologies ?? [:]).sorted { lhs, rhs in lhs.key == dataService && rhs.key != dataService }
        return ordered.map(\.value).map { technology in
            if technology.hasPrefix(prefix) {
                return String(technology.dropFirst(prefix.count))
            }
            return ShortRadioAccessTechnologyList(rawValue: technology)?.generation ?? "3G"
        }
    }

    private func isSIMInserted(_ technologies: [String: String]?) -> Bool {
        if #available(iOS 16.0, *) {
            return !(technologies?.isEmpty ?? true)
        }
        return !(networkInfo.serviceSubscriberCellularProviders?.isEmpty ?? true)
    }

    private var subscriberInfo: IosSubscriberMessage {
        let subscribers = CTSubscriberInfo.subscribers()
        let carrierTokens = subscribers.compactMap { $0.carrierToken?.base64EncodedString() }
        return IosSubscriberMessage(
            subscriberCount: Int64(subscribers.count),
            subscriberIdentifiers: subscribers.map { $0.identifier },
            carrierTokens: carrierTokens.isEmpty ? nil : carrierTokens
        )
    }

    private func currentPath() async -> NWPath? {
        await withCheckedContinuation { continuation in
            let once = OnceContinuation<NWPath?>(continuation)
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "carrier_info.path")
            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                once.resume(path)
            }
            monitor.start(queue: queue)
            queue.asyncAfter(deadline: .now() + firstValueTimeout) {
                monitor.cancel()
                once.resume(nil)
            }
        }
    }

    private func cellularDataRestriction() async -> String {
        if cellularData.restrictedState != .restrictedStateUnknown {
            return restrictionName(cellularData.restrictedState)
        }
        let cellularData = cellularData
        let state = await withCheckedContinuation { continuation in
            let once = OnceContinuation<CTCellularDataRestrictedState>(continuation)
            cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
                once.resume(state)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + firstValueTimeout) {
                once.resume(cellularData.restrictedState)
            }
        }
        cellularData.cellularDataRestrictionDidUpdateNotifier = nil
        return restrictionName(state)
    }

    private func restrictionName(_ state: CTCellularDataRestrictedState) -> String {
        switch state {
        case .restricted: return "restricted"
        case .notRestricted: return "notRestricted"
        case .restrictedStateUnknown: return "unknown"
        @unknown default: return "unknown"
        }
    }
}
