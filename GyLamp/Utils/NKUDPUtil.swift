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

enum NKUDPUtilError: Int, LocalizedError {
    
    case wrongDataReaded = -1
    case noDataReaded
    case cantReadLocalIp
    
    var localizedDescription: String {
        
        switch self {
            
            case .wrongDataReaded:
                return NSLocalizedString("udpUtil.wrongDataReaded", comment: "")
            case .noDataReaded:
                return NSLocalizedString("udpUtil.noDataReaded", comment: "")
            case .cantReadLocalIp:
                return NSLocalizedString("udpUtil.cantReadLocalIp", comment: "")
        }
        
    }
}

class NKUDPUtil {
    
    public static let shared = NKUDPUtil()
    
    private(set) var connection: UDPClient? = nil
    
    
    public func connect(ip: String, port: Int32 = 8888) -> Observable<Void> {
        
        if (self.connection != nil) {
            self.connection!.close()
            self.connection = nil
        }
        
        self.connection = UDPClient(address: ip, port: port)
        
        self.connection!.enableTimeout(sec: 1, usec: 0)
        
        let connection = self.connection!

        return Observable.create { observer in
    
            
            if let answ = connection.send(cmd: "DEB") {
                if answ.starts(with: "OK") {
                    NKLog("Device founded with ip:", ip, "Emmiting 'onNext'")
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    NKLog("An error occured while data sending. Emmiting 'onError'")
                    observer.onError(NKUDPUtilError.wrongDataReaded)
                    return Disposables.create()
                }
            } else {
                observer.onError(NKUDPUtilError.noDataReaded)
                NKLog("Wrong data receiving. Emmiting 'onError'")
                return Disposables.create()
            }
            
            return Disposables.create()
        }
    }
    
    public func scan() -> Observable<NKDeviceModel> {
        return Observable.create { observer in
            
            guard let deviceIp = UIDevice.current.getWiFiAddress() else {
                NKLog("Can`t get local ip adress. Emmiting 'onError'")
                observer.onError(NKUDPUtilError.cantReadLocalIp)
                return Disposables.create()
            }
            
            NKLog("Local ip:", deviceIp)
            
            let mask = deviceIp.split(separator: ".")
            
            var client: UDPClient? = nil
            
            
            
            for i in 1...255 {
                let deviceIp = "\(mask[0]).\(mask[1]).\(mask[2]).\(i)"
                
                client = UDPClient(address: deviceIp, port: 8888)
                
                client!.enableTimeout(sec: 0, usec: 50000)
                
                if let answ = client!.send(cmd: "DEB") {
                    if answ.starts(with: "OK") {
                        NKLog("Device founded with ip:", deviceIp,"Emmiting 'onNext'")
                        observer.onNext(NKDeviceModel(ip: deviceIp, port: 8888, isReachable: true))
                    }
                }
            
                client?.close()
                client = nil
                
            }
            
            
            observer.onCompleted()
            
            return Disposables.create()
        }
        
    }
    
    
    
    
}
