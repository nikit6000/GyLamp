//
//  NKGyverLampBetaSettingsSettingsRouter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

class NKGyverLampBetaSettingsRouter: NKGyverLampBetaSettingsRouterProtocol {

    static func createViewModule(ref: NKGyverLampBetaSettingsView) {
        let presenter = NKGyverLampBetaSettingsPresenter()
        let interactor = NKGyverLampBetaSettingsInteractor()
        let router = NKGyverLampBetaSettingsRouter()
        
        interactor.presenter = presenter
        
        presenter.view = ref
        presenter.interactor = interactor
        presenter.router = router
        
        ref.presenter = presenter
        
    }
    
    deinit {
        NKLog("NKGyverLampBetaSettingsRouter", "deinit")
    }
    
}
