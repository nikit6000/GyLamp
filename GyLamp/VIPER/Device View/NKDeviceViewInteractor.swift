//
//  NKDeviceViewInteractor.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import Alamofire

class NKDeviceViewInteractor: NKDeviceViewInteractorInputProtocol {
    
    var presenter: NKDeviceViewInteractorOutputProtocol?
    
    func makeData(device: NKDeviceModel) {
        
        let data: [ListDiffable] = [
            NKSectionModel(style: .top, title: NSLocalizedString("device.device", comment: "")),
            device,
            NKSectionModel(style: .top, title: NSLocalizedString("device.controls", comment: "")),
            device.sliders,
            NKSectionModel(style: .top, title: NSLocalizedString("device.mode", comment: "")),
            device.effects,
            NKSectionModel(style: .top, title: NSLocalizedString("device.alarms", comment: "")),
            device.alarms
        
        ]
        
        device.lampInterpretator.connect(onSuccess: { [weak self] in
            
            
            device.lampInterpretator.get(onSuccess: nil, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.presenter?.on(error: error)
                }
            })
            
            device.lampInterpretator.getAlarms()
            
            DispatchQueue.main.async {
                self?.presenter?.dataReady(data: data)
            }
            
        }, onError: { error in
            NKLog("[NKDeviceViewInteractor] connection error")
        })
        
        
        
    }
    
    func getMetaData(device: NKDeviceModel) {
        
    }
    
}
