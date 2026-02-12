//
//  NetworkMonitor.swift
//  dogCatAndI
//
//  Created by Sukrit Chatmeeboon on 7/2/2569 BE.
//

import Foundation
import Network

protocol NWMonitorServiceProtocol {
    var isConnected: Bool { get }
    var connectionType: NWInterface.InterfaceType? { get }
    var connectionTypeText: String { get }
    var interfaceType: NWInterface.InterfaceType? { get }

    func startMonitoring()
    func stopMonitoring()
}

class NWMonitorService: NWMonitorServiceProtocol {
    // MARK: - Property
    static let shared = NWMonitorService()

    private let queue = DispatchQueue.global(qos: .userInitiated)
    private let monitor: NWPathMonitor

    private(set) var isConnected: Bool = true
    private(set) var connectionType: NWInterface.InterfaceType?
    private(set) var connectionTypeText: String = "n/a"

    var interfaceType: NWInterface.InterfaceType? {
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }

    // MARK: - Life Cycle
    init() {
        self.monitor = NWPathMonitor()
        self.isConnected = monitor.currentPath.status == .satisfied
        (self.connectionType, self.connectionTypeText) = self.getConnectionType(monitor.currentPath)
    }

    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.isConnected = path.status == .satisfied
            (self.connectionType, self.connectionTypeText) = self.getConnectionType(path)
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    private func getConnectionType(_ path: NWPath) -> (NWInterface.InterfaceType?, String) {
        if path.usesInterfaceType(.cellular) {
            return (.cellular, "Cellular")
        } else if path.usesInterfaceType(.wifi) {
            return (.wifi, "WiFi")
        } else if path.usesInterfaceType(.wiredEthernet) {
            return (.wiredEthernet, "Wired Ethernet")
        } else if path.usesInterfaceType(.loopback) {
            return (.loopback, "Loopback")
        } else if path.usesInterfaceType(.other) {
            return (.other, "Other")
        } else {
            return (nil, "Unknown")
        }
    }
}
