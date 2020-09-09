//
//  NKScanDevicesPresenter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKScanDevicesPresenter: NKScanDevicesPresenterProtocol {
        
    var interactor: NKScanDevicesInteractorInputProtocol?
    
    weak var view: NKScanDevicesViewProtocol?
    
    var router: NKScanDevicesRouterProtocol?
    
    private var currentData: [ListDiffable] = []
    
    func viewDidLoad() {
        interactor?.getData()
        interactor?.subscribe()
    }
    
    func addDevice(by ip: String) {
        interactor?.addDevice(by: ip)
    }
    
    
}

extension NKScanDevicesPresenter: NKScanDevicesInteractorOutputProtocol {
    
    func needUpdate(sectionFor item: ListDiffable) {
        view?.updateSection(for: item, animated: true)
    }
    
    
    func scanDevicesFounded(_ deviceModels: [ListDiffable]) {
        
    }
    
    func storedSectionReady(_ deviceModels: [ListDiffable]) {
        
    }
    
    func scanDeviceFounded(_ deviceModel: NKDeviceModel) {
        
    }
    
    func dataReady(_ data: [ListDiffable]) {
        currentData = data
        view?.show(data: currentData, animated: true)
    }
    
    func errorHandler(_ error: Error) {
        
    }
    
    func manualModelReady(model: NKDeviceModel) {
        router?.pushView(device: model)
    }
    
    
}
