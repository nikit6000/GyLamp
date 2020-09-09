//
//  NKDeviceViewRouter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation

class NKDeviceViewRouter: NKDeviceViewRouterProtocol {

    static func createViewModule(ref: NKDeviceView) {
        let presenter = NKDeviceViewPresenter()
        let interactor = NKDeviceViewInteractor()
        let router = NKDeviceViewRouter()
        
        interactor.presenter = presenter
        
        
        presenter.view = ref
        presenter.interactor = interactor
        presenter.router = router
        
        ref.presenter = presenter
        
    }
    
    
}
