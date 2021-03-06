//
//  NKGyverLampBetaPresenter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKGyverLampBetaPresenter: NKGyverLampBetaPresenterProtocol {
    
    var interactor: NKGyverLampBetaInteractorInputProtocol?
    
    weak var view: NKGyverLampBetaProtocol?
    
    var router: NKGyverLampBetaRouterProtocol?
    
    func viewDidLoad() {
        
    }
}


extension NKGyverLampBetaPresenter: NKGyverLampBetaInteractorOutputProtocol {
    
    func dataReady(data: [ListDiffable]) {
        
    }
    
    func on(error: Error) {
        
    }
    

}
