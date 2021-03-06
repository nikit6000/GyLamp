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
    
    private var adHeaderModel = NKSectionModel(style: .bottom, title: NSLocalizedString("scan.ad", comment: ""))
    private var adModel = NKNativeAdModel(ad: "ca-app-pub-3597227208792915/8168587999")
    
    func makeData(device: NKDeviceModel) {
        
        let data: [ListDiffable] = [
            adHeaderModel,
            adModel,
            NKSectionModel(style: .top, title: NSLocalizedString("device.device", comment: "")),
            device,
            NKSectionModel(style: .top, title: NSLocalizedString("device.controls", comment: "")),
            device.sliders,
            NKSectionModel(style: .top, title: NSLocalizedString("device.mode", comment: "")),
            device.effects,
            NKSectionModel(style: .top, title: NSLocalizedString("device.alarms", comment: "")),
            device.alarms
        
        ]

    }
    
    func getMetaData(device: NKDeviceModel) {
        
    }
    
}
