//
//  NKUDPUtil.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 25/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftSocket

typealias UDPSuccessBlock = (_ answer: String) -> ()
typealias UDPErrorBlock = (_ answer: Error) -> ()

enum NKUDPUtilError: Int, LocalizedError {
    
    case wrongDataReaded = -1
    case noDataReaded
    case cantReadLocalIp
    case noConnection
    case busy
    
    var localizedDescription: String {
        
        switch self {
            
            case .wrongDataReaded:
                return NSLocalizedString("udpUtil.wrongDataReaded", comment: "")
            case .noDataReaded:
                return NSLocalizedString("udpUtil.noDataReaded", comment: "")
            case .cantReadLocalIp:
                return NSLocalizedString("udpUtil.cantReadLocalIp", comment: "")
            case .noConnection:
                return NSLocalizedString("udpUtil.noConnection", comment: "")
            case .busy:
                return NSLocalizedString("udpUtil.busy", comment: "")
        }
        
    }
}

class NKUDPUtil {
    
    public static let shared = NKUDPUtil()
    
    private let discovery: SSDPDiscovery = SSDPDiscovery.defaultDiscovery
    fileprivate var session: SSDPDiscoverySession?
    
    fileprivate var disposeBag = DisposeBag()
    
    public var deviceSubject = PublishSubject<NKDeviceModel?>()
    
   
    
    public func searchForDevices() {
        // Create the request for Sonos ZonePlayer devices
        //let zonePlayerTarget = SSDPSearchTarget.deviceType(schema: SSDPSearchTarget.upnpOrgSchema, deviceType: "upnp:rootdevice", version: 1)
        let request = SSDPMSearchRequest(delegate: self, searchTarget: .rootDevice)
    
        // Start a discovery session for the request and timeout after 10 seconds of searching.
        self.session = try! discovery.startDiscovery(request: request, timeout: 10.0)
    }
    
    public func stopSearching() {
        self.session?.close()
        self.session = nil
    }
    
}


extension NKUDPUtil: SSDPDiscoveryDelegate {
    
    public func discoveredDevice(response: SSDPMSearchResponse, session: SSDPDiscoverySession) {
        
        let ssdpUtil = SSDPUtil.shared
        NKLog("SSDP", response.location)
        ssdpUtil.getDevice(description: response.location).subscribe(onNext: { [weak self] model in
            
            self?.deviceSubject.onNext(model)
            
        }).disposed(by: disposeBag)
    }

    public func discoveredService(response: SSDPMSearchResponse, session: SSDPDiscoverySession) {
    }

    public func closedSession(_ session: SSDPDiscoverySession) {
        self.deviceSubject.onNext(nil)
    }

}
