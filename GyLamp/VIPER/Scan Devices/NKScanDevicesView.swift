//
//  ViewController.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import Material
import IGListKit
import RxSwift

class NKScanDeviceView: NKBlurViewController, NKScanDevicesViewProtocol {
    
    private var data: [ListDiffable] = []
    public var presenter: NKScanDevicesPresenterProtocol? = nil
    
    
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
        view.addTarget(self, action: #selector(NKScanDeviceView.scanDevices), for: .touchUpInside)
        return view
    }()
    
    private lazy var addButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.add?.tint(with: .white)
        view.addTarget(self, action: #selector(NKScanDeviceView.addDevice), for: .touchUpInside)
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(NKScanDeviceView.scanDevices), for: .valueChanged)
        return control
        
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.image = #imageLiteral(resourceName: "bg")
        self.effect = UIBlurEffect(style: .dark)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addButton), UIBarButtonItem(customView: scanButton)]
        
        self.collectionView.nkDelegate = self
        self.collectionView.addSubview(refreshControl)
        
        NKScanDevicesRouter.createScanModule(ref: self)

        presenter?.viewDidLoad()
    }
    
    
    func show(data: [ListDiffable], animated: Bool) {
        self.data = data
        if (animated) {
            adapter.performUpdates(animated: true, completion: nil)
        } else {
            adapter.reloadData(completion: nil)
        }
        
    }
    
    func updateSection(for item: ListDiffable, animated: Bool) {
        
        guard let sectionController = adapter.sectionController(for: item) else {
            return
        }
        
        sectionController.collectionContext?.performBatch(animated: animated, updates: { batch in
            batch.reload(sectionController)
        }, completion: nil)
        
    }
    
    @objc private func scanDevices() {
        self.refreshControl.hideAnimated { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.refreshControl.isHidden = false
        }
        presenter?.interactor?.scanForDevices()
    }
    
    @objc private func addDevice() {
        
        let title = NSLocalizedString("scan.enterip", comment: "")
        let message = "xxx.xxx.xxx.xxx:port"
        let placeholder = NSLocalizedString("scan.ip", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = placeholder
        }

        alert.addAction(UIAlertAction(title: NSLocalizedString("scan.connect", comment: ""), style: .default, handler: { [weak self] (_) in
            let textField = alert.textFields?.first
            
            guard let ipStr = textField?.text else {
                return
            }
            
            self?.presenter?.addDevice(by: ipStr)
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("scan.cancel", comment: ""), style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }

}

extension NKScanDeviceView: ListAdapterDataSource, NKCollectionViewDelegate {
    
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
        case is NKDeviceModel:
            let controller = NKDeviceController()
            return controller
        case is String:
            return NKTextController()
        default:
            fatalError()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    
    
}

