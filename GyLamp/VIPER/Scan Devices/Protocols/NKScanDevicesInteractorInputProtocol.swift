//
//  NKScanDevicesInteractorInputProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import RxSwift

protocol NKScanDevicesInteractorInputProtocol: class {
    var presenter: NKScanDevicesInteractorOutputProtocol? {get set}
    
    func subscribe()
    
    func getData()
    func getSavedDevices()
    func scanForDevices()
    
    func addDevice(by ip: String)
    func configureDataStorage()
    
}
