//
//  NKGyverLampBetaSettingsView.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit
import Material

class NKGyverLampBetaSettingsView: NKBlurViewController, NKGyverLampBetaSettingsProtocol, Themeable {
    
    public var presenter: NKGyverLampBetaSettingsPresenterProtocol?
    public var tableData: [ListDiffable] = []
    
    private weak var transport: NKTransport?
    private var key: String
    private var channel: UInt
    
    var isThemingEnabled: Bool = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        
        adapter.dataSource = self
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
        
        return adapter
    }()
    
    init(transport: NKTransport?, channel: UInt, key: String) {
        self.transport = transport
        self.channel = channel
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Not allowed! Use init(transport:, frame)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.effect = .none
        self.collectionView.delaysContentTouches = false
        self.collectionView.isMultipleTouchEnabled = false
        
        self.view.backgroundColor = Theme.current.background
        self.title = "gyverLampBetaView.settings".localized

        NKGyverLampBetaSettingsRouter.createViewModule(ref: self)
        presenter?.viewDidLoad()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        self.navigationController?.navigationBar.tintColor = Theme.current.onBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.interactor?.transport = transport
        presenter?.interactor?.key = key
        presenter?.interactor?.channel = channel
        
        
    }
    
    func show(data: [ListDiffable], animated: Bool) {
        tableData = data
        adapter.reloadData(completion: nil)
        
    }
    
    func show(error: Error) {
        
    }
    
    func apply(theme: Theme) {
        view.backgroundColor = theme.background
        navigationController?.navigationBar.tintColor = theme.onBackground
    }
    
    deinit {
        // Clean up
        presenter?.interactor = nil
        presenter?.router = nil
        NKLog("NKGyverLampBetaSettingsView", "deinit")
    }
}

extension NKGyverLampBetaSettingsView: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return tableData
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is NKEnumSectionModel:
            let controller = NKListParamSectionController()
            controller.delegate = presenter?.interactor
            return controller
        default:
            fatalError()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
