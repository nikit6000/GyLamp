//
//  NKScanDevicesRouter.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKScanDevicesRouter: NKScanDevicesRouterProtocol {
    
    var view: NKScanDeviceView?
    
    
    static func createScanModule(ref: NKScanDeviceView) {
        let presenter = NKScanDevicesPresenter()
        let interactor = NKScanDevicesInteractor()
        let router = NKScanDevicesRouter()
        
        interactor.presenter = presenter
        
        router.view = ref
        
        presenter.view = ref
        presenter.interactor = interactor
        presenter.router = router
        
        ref.presenter = presenter
        
    }
    
    
    func pushView(device: NKDeviceModel) {
        let deviceController = NKDeviceView(device: device)
        presentView(view: deviceController)
    }
    
    func presentGyverLampBetaView() {
        let gyverLampBetaView = NKGyverLampBetaView()
        presentView(view: gyverLampBetaView)
    }
    
    private func presentView(view controller: UIViewController) {
        if #available(iOS 12.0, *) {
            let navigationController = UINavigationController(navigationBarClass: NKNavigationBar.self, toolbarClass: nil)
            navigationController.modalPresentationStyle = .formSheet
            navigationController.viewControllers = [controller]
            view?.present(navigationController, animated: true, completion: nil)
        } else {
            view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
