//
//  NKScanDevicesPresenterProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation

protocol NKScanDevicesPresenterProtocol: class {
    
    var interactor: NKScanDevicesInteractorInputProtocol? {get set}
    var view: NKScanDevicesViewProtocol? {get set}
    var router: NKScanDevicesRouterProtocol? {get set}
    
    func viewDidLoad()
    
    func addDevice(by ip: String)
    
}
