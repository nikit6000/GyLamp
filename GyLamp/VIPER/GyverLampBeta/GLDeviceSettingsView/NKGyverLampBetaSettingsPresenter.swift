//
//  NKGyverLampBetaSettingsSettingsPresenter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKGyverLampBetaSettingsPresenter: NKGyverLampBetaSettingsPresenterProtocol {
    
    var interactor: NKGyverLampBetaSettingsInteractorInputProtocolWithDelegate?
    
    weak var view: NKGyverLampBetaSettingsProtocol?
    
    var router: NKGyverLampBetaSettingsRouterProtocol?
    
    func viewDidLoad() {
        interactor?.loadData()
    }
    
    deinit {
        NKLog("NKGyverLampBetaSettingsPresenter", "deinit")
    }
}


extension NKGyverLampBetaSettingsPresenter: NKGyverLampBetaSettingsInteractorOutputProtocol {
    
    func dataReady(data: [ListDiffable]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.show(data: data, animated: false)
        }
    }
    
    func on(error: Error) {
        
    }
    

}
