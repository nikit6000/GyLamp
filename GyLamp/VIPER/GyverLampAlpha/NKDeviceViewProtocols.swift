//
//  NKDeviceViewProtocols.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

protocol NKDeviceViewRouterProtocol: class {
    
    static func createViewModule(ref: NKDeviceView)
    
}

protocol NKDeviceViewProtocol: class {
    
    func show(data: [ListDiffable], animated: Bool)
    func show(error: Error)
    
}

protocol NKDeviceViewPresenterProtocol: class {
    
    var interactor: NKDeviceViewInteractorInputProtocol? {get set}
    var view: NKDeviceViewProtocol? {get set}
    var router: NKDeviceViewRouterProtocol? {get set}
    
    func viewDidLoad()
}

protocol NKDeviceViewInteractorInputProtocol: class {
    var presenter: NKDeviceViewInteractorOutputProtocol? {get set}
    
    func makeData(device: NKDeviceModel)
    
}

protocol NKDeviceViewInteractorOutputProtocol: class {
    
    func dataReady(data: [ListDiffable])
    func on(error: Error)
    
}



