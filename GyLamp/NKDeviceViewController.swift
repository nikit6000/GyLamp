//
//  NKDeviceViewController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import Material
import IGListKit
import RxSwift

class NKDeviceViewController: UIViewController {
    
    private var disposeBag: DisposeBag!
    private var model: NKDeviceModel?
    private var headerModel = NKSectionModel(style: .bottom)
    
    
    fileprivate var data: [Any] = []
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true)
        //layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        return collectionView
        
    }()
    
    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        
        adapter.dataSource = self
        adapter.collectionView = collectionView
        
        return adapter;
    }()
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.937254902, green: 0.4235294118, blue: 0, alpha: 1)
        let bottomColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.1333333333, alpha: 1)
        
        layer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.locations = [0.0, 1.0]
        
        return layer
    }()
    
    private lazy var scanButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.search?.tint(with: .white)
        //view.addTarget(self, action: #selector(ViewController.scan), for: .touchUpInside)
        return view
    }()
    
    private lazy var addButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.add?.tint(with: .white)
        //view.addTarget(self, action: #selector(ViewController.add), for: .touchUpInside)
        return view
    }()
    
    convenience init(model: NKDeviceModel){
        self.init(nibName: nil, bundle: nil)
        self.model = model
        withUnsafePointer(to: &self.model) {
            NKLog("Model has adress:",$0)
        }
        
        disposeBag = DisposeBag()
        
        headerModel.title = NSLocalizedString("device.title", comment: "")
        headerModel.isLoading = true
        
        setupInterface()
        
        data.append(headerModel)
        data.append(model)
        data.append(NKSectionModel(style: .bottom, title: NSLocalizedString("device.controls", comment: "")))
        data.append(NKFloatModel(value: 0.0, text: "Bright"))
        data.append(NKFloatModel(value: 0.0, text: "Speed"))
        data.append(NKFloatModel(value: 0.0, text: "Scale"))
        data.append(NKSectionModel(style: .bottom, title: NSLocalizedString("device.mode", comment: "")))
        
        adapter.reloadData(completion: nil)
        
        model.read().subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                
                NKLog("Data read error:", error.localizedDescription)
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.headerModel.isLoading = false
                strongSelf.adapter.reloadObjects([strongSelf.headerModel])
            }, onCompleted: { [weak self] in
                    
                guard let strongSelf = self, let model = strongSelf.model else {
                    return
                }
                strongSelf.headerModel.isLoading = false
                strongSelf.adapter.reloadObjects([strongSelf.headerModel])
                strongSelf.data.append(NKCollectionModel(model: model))
                strongSelf.adapter.performUpdates(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
    }
    
    deinit {
        NKLog("DeviceVC deinited")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.barStyle = .black
        
        super.viewWillAppear(animated)
    }
    
    private func setupInterface() {
        
        self.title = NSLocalizedString("scan.title", comment: "")
        
        self.view.addSubview(collectionView)
        
        setupConstarints()
        
    }
    
    
    private func setupConstarints() {
        
        /* collectionView */
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: collectionView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = view.bounds
        super.viewDidLayoutSubviews()
    }
    
}

extension NKDeviceViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is NKSectionModel:
            return NKHeaderSectionController()
        case is NKDeviceModel:
            return NKDeviceController()
        case is NKCollectionModel:
            return NKEmbededCollectionController()
        case is NKFloatModel:
            return NKSliderController()
        default:
            fatalError()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    
}
