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
    
    private var connection: UDPClient? = nil
    
    
    public func connect(ip: String, port: Int32 = 8888) -> Observable<Void> {
        
        if (self.connection != nil) {
            self.connection!.close()
            self.connection = nil
        }
        
        self.connection = UDPClient(address: ip, port: port)
        
        let connection = self.connection!

        return Observable.create { observer in
    
            let status = connection.send(string: "DEB")
            
            switch status{
            case .success:
                let received = connection.recv(512)
                
                guard let data = received.0, let responseStr = String(bytes: data, encoding: .utf8) else {
                    observer.onError(NKUDPUtilError.noDataReaded)
                    NKLog("Wrong data receiving. Emmiting 'onError'")
                    return Disposables.create()
                }
                
                NKLog("Received", responseStr)
                
                if responseStr.starts(with: "OK") {
                    
                    NKLog("Device responsed. Emmiting 'onComplete'")
                    
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    NKLog("Device answered with wrong byte sequence. Emmiting 'onError'")
                    observer.onError(NKUDPUtilError.wrongDataReaded)
                }
                
                
                
                return Disposables.create()
            case .failure(let error):
                NKLog("An error occured while data sending. Emmiting 'onError'")
                observer.onError(error)
                return Disposables.create()
            }
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
                
                client = nil
                client = UDPClient(address: deviceIp, port: 8888)
                
                let status = client!.send(string: "DEB")
                
                switch status {
                case .success:
                    let received = client!.recv(512)
                    
                    if let data = received.0, let responseStr = String(bytes: data, encoding: .utf8) {
                        if responseStr.starts(with: "OK") {
                            
                            NKLog("Device founded with ip:", deviceIp,"Emmiting 'onNext'")
                            
                            observer.onNext(NKDeviceModel(ip: deviceIp, port: 8888))
                        }
                    } else {
                        NKLog("Device with ip", deviceIp,"not founded")
                    }
                    
                    break
                case .failure(_):
                    continue
                }
                
            }
            
            client = nil
            
            observer.onCompleted()
            
            return Disposables.create()
        }
        
    }
    
    
}
