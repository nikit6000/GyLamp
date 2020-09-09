//
//  NKScanDevicesRouterProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation

protocol NKScanDevicesRouterProtocol: class {
    
    var view: NKScanDeviceView? { get set }
    
    static func createScanModule(ref: NKScanDeviceView)
    
    func pushView(device: NKDeviceModel)
}
