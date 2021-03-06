//
//  NKDeviceView.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import Material
import IGListKit
import RxSwift

class NKDeviceView: NKBlurViewController, NKDeviceViewProtocol {
    
    private let adSectionController = NKAdsSectionController()
    
    private var data: [ListDiffable] = []
    private(set) var deviceModel: NKDeviceModel
    
    public var presenter: NKDeviceViewPresenterProtocol? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        
        adapter.dataSource = self
        adapter.collectionView = collectionView
        
        return adapter;
    }()
    
    private lazy var scanButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.search?.tint(with: .white)
        //view.addTarget(self, action: #selector(NKScanDeviceView.scanDevices), for: .touchUpInside)
        return view
    }()
    
    private lazy var closeButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.close?.tint(with: .white)
        
        view.addTarget(self, action: #selector(NKDeviceView.closeAction), for: .touchUpInside)
        return view
    }()
    
    init(device: NKDeviceModel) {
        deviceModel = device
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //self.image = #imageLiteral(resourceName: "bg")
        self.effect = UIBlurEffect(style: .dark)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        self.navigationItem.hidesBackButton = true
        
        self.collectionView.nkDelegate = self
    
        self.collectionView.delaysContentTouches = false
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        
        
        NKDeviceViewRouter.createViewModule(ref: self)

        presenter?.viewDidLoad()
        
        presenter?.interactor?.makeData(device: deviceModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         disableDismissalRecognizers()
    }
    
    func show(data: [ListDiffable], animated: Bool) {
        self.data = data
        if (animated) {
            adapter.performUpdates(animated: true, completion: nil)
        } else {
            adapter.reloadData(completion: nil)
        }
    }
    
    @objc private func closeAction() {
        
        if self.isModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func disableDismissalRecognizers() {
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = false
        }
    }
    
    private func enableDismissalRecognizers() {
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = true
        }
    }

    public func show(error: Error) {
        
        let description: String
        
        if let error = error as? NKUDPUtilError {
            description = error.localizedDescription
        } else {
            description = error.localizedDescription
        }
        
        let title = NSLocalizedString("device.error", comment: "")
        let quit = NSLocalizedString("device.quit", comment: "")
        let stay = NSLocalizedString("device.stay", comment: "")
        
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        
        let quitAction = UIAlertAction(title: quit, style: .default, handler: { [weak self] _ in
            self?.closeAction()
        })
        
        let stayAction = UIAlertAction(title: stay, style: .default, handler: nil)
        
        alert.addAction(quitAction)
        alert.addAction(stayAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        NKLog("[NKDeviceView] - deinit")
    }
    
}

extension NKDeviceView: ListAdapterDataSource, NKCollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectExtendedItemAt indexPath: IndexPath) {
        let sectionController = adapter.sectionController(forSection: indexPath.section)
        
        sectionController?.didLongPress(item: indexPath.item)
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is NKSectionModel:
            return NKHeaderSectionController()
        case is String:
            return NKTextController()
        case is NKSlidersModel:
            return NKEmbededSlidersController()
        case is NKAlarmsModel:
            return NKEmbededAlarmsController()
        case is NKEffects:
            return NKEmbededEffectsController()
        case is NKAdModel:
            return adSectionController
        default:
            fatalError()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    
    
}

