//
//  NKGyverLampBetaRouter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

class NKGyverLampBetaRouter: NKGyverLampBetaRouterProtocol {

    var view: NKGyverLampBetaView?
    
    static func createViewModule(ref: NKGyverLampBetaView) {
        let presenter = NKGyverLampBetaPresenter()
        let interactor = NKGyverLampBetaInteractor()
        let router = NKGyverLampBetaRouter()
        let transport = UDPTransport()
        
        transport.connect(to: "192.168.0.255", port: 8888)
        
        transport.isBroadcastEnabled = true
        
        interactor.transport = transport
        
        interactor.presenter = presenter
        
        router.view = ref
        
        presenter.view = ref
        presenter.interactor = interactor
        presenter.router = router
        
        ref.presenter = presenter
        
    }
    
    func showDeviceSettings(transport: NKTransport?, channel: UInt, key: String) {
        let settingsView = NKGyverLampBetaSettingsView(transport: transport, channel: channel, key: key)
        view?.navigationController?.pushViewController(settingsView, animated: true)
    }
    
    
}
