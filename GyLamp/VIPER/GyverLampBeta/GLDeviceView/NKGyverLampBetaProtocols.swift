//
//  NKGyverLampBetaProtocols.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

protocol NKGyverLampBetaRouterProtocol: class {
    
    var view: NKGyverLampBetaView? { get set }
    
    static func createViewModule(ref: NKGyverLampBetaView)
    
    func showDeviceSettings(transport: NKTransport?, channel: UInt, key: String)
    
}

protocol NKGyverLampBetaProtocol: class {
    
    func show(data: [ListDiffable], animated: Bool)
    func show(error: Error)
    
}

protocol NKGyverLampBetaPresenterProtocol: class {
    
    var interactor: NKGyverLampBetaInteractorInputProtocol? {get set}
    var view: NKGyverLampBetaProtocol? {get set}
    var router: NKGyverLampBetaRouterProtocol? {get set}
    
    func viewDidLoad()
}

protocol NKGyverLampBetaInteractorInputProtocol: class {
    var presenter: NKGyverLampBetaInteractorOutputProtocol? {get set}
    
    var transport: NKTransport? { get set }
    
    func makeData(device: NKDeviceModel)
    
}

protocol NKGyverLampBetaInteractorOutputProtocol: class {
    
    func dataReady(data: [ListDiffable])
    func on(error: Error)
    
}
