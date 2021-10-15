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
    
    private var storedDevicesSection: [NKDeviceModel] = []
    private var findedDevicesSection: [NKDeviceModel] = []
    
    private var isFirstSearch: Bool = false
    
    var presenter: NKScanDevicesInteractorOutputProtocol?
    
    func subscribe() {
        
        let worker = NKCoreDataWorker.shared
        let udp = NKUDPUtil.shared
        
        worker.modelChangeSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                self?.modelSaveStateChanged(model: model)
            }, onError: { [weak self] error in
                self?.presenter?.errorHandler(error)
            })
            .disposed(by: disposeBag)
        
        udp.deviceSubject
            .filter { [weak self] model in
                
                guard let model = model else {
                    return true
                }
                
                let index = self?.storedDevicesSection.firstIndex {
                    return model.isEqual(toDiffableObject: $0)
                }
                
                if index != nil {
                    self?.storedDevicesSection[index!].isReachable = true
                    DispatchQueue.main.async {
                        
                        guard let strongSelf = self, let index = index else {
                            return
                        }
                        
                        strongSelf.presenter?.needUpdate(sectionFor: strongSelf.storedDevicesSection[index])
                    }
                    
                    return false
                }
                
                return true
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] model in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard let model = model else {
                    
                    strongSelf.findedHeaderModel.isLoading = false
                    strongSelf.presenter?.needUpdate(sectionFor: strongSelf.findedHeaderModel)
                    strongSelf.isFirstSearch = false
                    strongSelf.dataReady()
                    
                    return
                }
                
                model.isReachable = true
                self?.findedDevicesSection.append(model)
                self?.dataReady()
            }, onError: { [weak self] error in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.presenter?.errorHandler(error)
                strongSelf.findedHeaderModel.isLoading = false
                strongSelf.presenter?.needUpdate(sectionFor: strongSelf.findedHeaderModel)
            }, onCompleted: { [weak self] in
                guard let strongSelf = self else {
                   return
                }

                strongSelf.findedHeaderModel.isLoading = false
                strongSelf.presenter?.needUpdate(sectionFor: strongSelf.findedHeaderModel)
                strongSelf.isFirstSearch = false
                strongSelf.dataReady()
            })
            .disposed(by: disposeBag)
    
        
    }
    
    func getData() {
        getSavedDevices()
    }
    
    func getSavedDevices() {
    
        let worker = NKCoreDataWorker.shared
        
        isFirstSearch = true
        
        worker.rx.loadModels(of: NKDeviceModel.self)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                self?.storedDevicesSection.append(model)
            }, onError: { [weak self] error in
                self?.presenter?.errorHandler(error)
                self?.scanForDevices()
            }, onCompleted: { [weak self] in
                self?.dataReady()
                self?.scanForDevices()
            })
            .disposed(by: disposeBag)
        
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
