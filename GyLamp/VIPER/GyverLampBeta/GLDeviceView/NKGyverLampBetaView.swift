//
//  NKGyverLampBetaView.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit
import Material

class NKGyverLampBetaView: NKBlurViewController, NKGyverLampBetaProtocol {
    
    public var presenter: NKGyverLampBetaPresenterProtocol?
    
    private var collectionData: [ListDiffable]?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        
        adapter.dataSource = self
        adapter.collectionView = collectionView
        
        return adapter
    }()
    
    private lazy var settingsButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.settings?.tint(with: .white)
        view.addTarget(self, action: #selector(NKGyverLampBetaView.settingsButtonHandler), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        
        self.effect = UIBlurEffect(style: .dark)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingsButton)]

        self.title = "GyverLamp V2"
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        
        NKGyverLampBetaRouter.createViewModule(ref: self)
        presenter?.viewDidLoad()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.tintColor = .white
        }
    }
    
    func show(data: [ListDiffable], animated: Bool) {
        collectionData = data
    }
    
    func show(error: Error) {
        
    }
    
    @objc private func settingsButtonHandler() {
        presenter?.router?.showDeviceSettings(transport: presenter?.interactor?.transport, channel: 1, key: "TransportKey")
    }
    
    deinit {
        presenter?.interactor = nil
        presenter?.router = nil
    }
}

extension NKGyverLampBetaView: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return collectionData ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        fatalError()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
