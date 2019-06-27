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

class ViewController: UIViewController {

    private var disposeBag: DisposeBag!
    private var isLoading: Bool = false
    
    let findSection = NKSectionModel(style: .top, title: NSLocalizedString("scan.finded", comment: ""))
    
    fileprivate var data: [Any] = []
    private var foundedDevicesStartIndex: Int = 0
    
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
        view.addTarget(self, action: #selector(ViewController.scan), for: .touchUpInside)
        return view
    }()
    
    private lazy var addButton: IconButton = {
        let view = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.image = Icon.add?.tint(with: .white)
        view.addTarget(self, action: #selector(ViewController.add), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: addButton),
            UIBarButtonItem(customView: scanButton)
        ]
        
        setupInterface()
        
        data.append(NKSectionModel(style: .top, title: NSLocalizedString("scan.saved", comment: "")))
        data.append(NKDeviceModel(ip:"255.255.255.255"))
        data.append(NKDeviceModel(ip:"255.255.255.265"))
        data.append(NKDeviceModel(ip:"255.255.255.261"))
        data.append(NKDeviceModel(ip:"255.255.255.221"))
        data.append(findSection)
        
        foundedDevicesStartIndex = data.count
        
        adapter.reloadData(completion: nil)
        
        scan()
        // Do any additional setup after loading the view.
    }
    
    @objc private func add() {
        
    }
    
    @objc private func scan() {
        if isLoading {
            return
        }
        
        //let section = adapter.sectionController(for: findSection)
        
        isLoading = true
        findSection.isLoading = true
       
        adapter.reloadObjects([findSection])
        
        if data.count > foundedDevicesStartIndex {
            data.removeLast(data.count - foundedDevicesStartIndex)
            adapter.performUpdates(animated: true, completion: nil)
        }
        
        
        
        NKUDPUtil.shared.scan()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] device in
                NKLog("Device:", device.ip)
                self?.data.append(device)
                self?.adapter.performUpdates(animated: true, completion: nil)
            }, onError: { [weak self] error in
                NKLog(error)
                self?.isLoading = false
                self?.findSection.isLoading = false
            }, onCompleted: { [weak self] in
                NKLog("completed")
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.isLoading = false
                strongSelf.findSection.isLoading = false
                strongSelf.adapter.reloadObjects([strongSelf.findSection])
            })
            .disposed(by: disposeBag)
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
        
        /*if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }*/
        
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

extension ViewController: ListAdapterDataSource, NKSectionControllerDelegate {
    
    func didSelect(controller: ListSectionController, in section: Int, at index: Int) {
        guard let controller = controller as? NKDeviceController else {
            return
        }
        
        let model = controller.model!
        
        
        
        NKUDPUtil.shared.connect(ip: model.ip, port: model.port)
                        .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
                        .observeOn(MainScheduler.instance)
                        .subscribe(onError: { _ in
                            
                        }, onCompleted: { [weak self] in
                            let deviceController = NKDeviceViewController(model: model)
                            self?.navigationController?.pushViewController(deviceController, animated: true)
                        })
                        .disposed(by: disposeBag)
        
        
    }
    
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is NKSectionModel:
            return NKHeaderSectionController()
        case is NKDeviceModel:
            let controller = NKDeviceController()
            controller.delegate = self
            return controller
        default:
            fatalError()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    
}

