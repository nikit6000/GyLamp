//
//  NKScanDevicesInteractor.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

class NKScanDevicesInteractor: NKScanDevicesInteractorInputProtocol {
    
    private var disposeBag = DisposeBag()
    
    private var storedHeaderModel = NKSectionModel(style: .bottom, title: NSLocalizedString("scan.saved", comment: ""))
    private var findedHeaderModel = NKSectionModel(style: .bottom, title: NSLocalizedString("scan.finded", comment: ""))
    private var adHeaderModel = NKSectionModel(style: .bottom, title: NSLocalizedString("scan.ad", comment: ""))
    //private var adModel = NKNativeAdModel(ad: "ca-app-pub-3597227208792915/9854007081")
    
    private var storedDevicesSection: [NKDeviceModel] = []
    private var findedDevicesSection: [NKDeviceModel] = []
    
    private var isFirstSearch: Bool = false
    
    var presenter: NKScanDevicesInteractorOutputProtocol?
    
    func subscribe() {

    }
    
    func getData() {
        getSavedDevices()
    }
    
    func getSavedDevices() {

    }
    
    func scanForDevices() {
        
        if findedHeaderModel.isLoading == true {
            return
        }
        
        let udp = NKUDPUtil.shared
        
        findedHeaderModel.isLoading = true
        
        self.presenter?.needUpdate(sectionFor: self.findedHeaderModel)
        
        findedDevicesSection.removeAll()
        
        udp.searchForDevices()
        
        
    }
    
    private func dataReady() {
        
        var data: [ListDiffable] = []
        
        //data.append(adHeaderModel)
        //data.append(adModel)
        
        if (storedDevicesSection.count > 0) {
            data.append(storedHeaderModel)
            data += storedDevicesSection
        }
        
        data.append(findedHeaderModel)
        
        if isFirstSearch && findedDevicesSection.count == 0 {
            data.append(NSLocalizedString("scan.hereYouCanSeeDevices", comment: "") as ListDiffable)
        } else if !findedHeaderModel.isLoading && findedDevicesSection.count == 0 {
            data.append(NSLocalizedString("scan.notFounded", comment: "") as ListDiffable)
        } else {
            data += findedDevicesSection
        }
        
        presenter?.dataReady(data)
    }
    
    func addDevice(by ip: String) {
        let splitResult = ip.components(separatedBy: ":")
        
        guard let address = splitResult.first, let portStr = splitResult.last, let port = Int32(portStr) else {
            return
        }
        
        let model = NKDeviceModel(ip: address, port: port, isReachable: false)
        
        presenter?.manualModelReady(model: model)
    }
    
    func configureDataStorage() {
        
        CoreStoreUtil.shared.initStorage(onProgress: { progress in
            
        }, onSuccess: { [weak self] in
            self?.presenter?.presentGyverLampBeta()
        }, onError: { [weak self] error in
            self?.presenter?.errorHandler(error)
        })
        
    }
    
    private func modelSaveStateChanged(model: NKModel) {
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            if (model.managedObject == nil) {
                let index = self?.storedDevicesSection.firstIndex {
                    return $0.isEqual(toDiffableObject: model)
                }
                    
                if index != nil {
                    self?.storedDevicesSection.remove(at: index!)
                    
                    DispatchQueue.main.async {
                        self?.dataReady()
                    }
                    
                }
            } else {
                let index = self?.findedDevicesSection.firstIndex {
                    return $0.isEqual(toDiffableObject: model)
                }
                
                if index != nil {
                    self?.findedDevicesSection.remove(at: index!)
                }
                
                if let model = model as? NKDeviceModel {
                    self?.storedDevicesSection.append(model)
                    
                    DispatchQueue.main.async {
                        self?.dataReady()
                    }
                }
                
                
            }
            
        }
        
        
    }
    
    
    
    
}
