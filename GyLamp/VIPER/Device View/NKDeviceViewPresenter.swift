//
//  NKDeviceViewPresenter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKDeviceViewPresenter: NKDeviceViewPresenterProtocol {
    
    var interactor: NKDeviceViewInteractorInputProtocol?
    
    weak var view: NKDeviceViewProtocol?
    
    var router: NKDeviceViewRouterProtocol?
    
    func viewDidLoad() {
        
    }
    
    
}


extension NKDeviceViewPresenter: NKDeviceViewInteractorOutputProtocol {
    
    func dataReady(data: [ListDiffable]) {
        view?.show(data: data, animated: true)
    }
    
    func on(error: Error) {
        view?.show(error: error)
    }

}
