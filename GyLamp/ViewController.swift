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
    
    fileprivate var data: [Any] = [NKSectionModel(style: .top, title: "Text"),
                                    NKSectionModel(style: .bottom, title: "Big text"),
                                    NKSectionModel(style: .top, title: "Very big text"),
                                    NKSectionModel(style: .top, title: "Very very very very very very very very very very very very very very very very very over very big text"),
                                    NKSectionModel(style: .top, title: "Text")]
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 40)
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        
        setupInterface()
        
        //adapter.reloadData(completion: nil)
        
        NKUDPUtil.shared.scan()
                        .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { device in
                            NKLog("Device:", device.ip)
                        }, onError: { error in
                            NKLog(error)
                        }, onCompleted: {
                            NKLog("completed")
                        })
                        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    
    private func setupInterface() {
        
        self.title = NSLocalizedString("scan.title", comment: "")
        self.view.backgroundColor = .lightGray
        
        self.view.addSubview(collectionView)
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        
        setupConstarints()
        
        let disposeable = ColorUtil.shared.colorizer.subscribe(onNext: { value in
            self.collectionView.backgroundColor = value.palette[.collectionBackground]
            self.view.backgroundColor = value.palette[.primary]
            self.navigationController?.navigationBar.barStyle = value.barStyle
        })
        
        disposeable.disposed(by: disposeBag)
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


}

extension ViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is NKSectionModel:
            return NKHeaderSectionController()
        default:
            fatalError()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
    
}

