//
//  NKEmbededCollectionController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

class NKEmbededCollectionController: ListSectionController {
    
    var model: NKCollectionModel!
    var disposeBag: DisposeBag = DisposeBag()
    
    private var lastSelectedIndex: Int? = nil
    
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = collectionContext!.containerSize
        
        let onScreenCount: CGFloat
        
        if UIScreen.main.scale == 3.0 {
            /* iPhone 7 Plus and above*/
            onScreenCount = 4.3
        } else  {
            onScreenCount = 3.3
        }
        
        return CGSize(width: size.width, height: size.width / onScreenCount + 8)
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: NKCollectionCell.self, for: self, at: index) as? NKCollectionCell else {
            fatalError()
        }
        
        self.adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let model = object as? NKCollectionModel else {
            return
        }
        self.model = model
        self.adapter.reloadData(completion: nil)
        
        //let deviceModel = self.model.deviceModel
        
        
    }
    
}

extension NKEmbededCollectionController: ListAdapterDataSource, NKSectionControllerDelegate {
    
    func didSelect(controller: ListSectionController, in section: Int, at index: Int) {
        guard let mode = NKDeviceMode(rawValue: section) else {
            return
        }
        
        model.deviceModel.mode.accept(mode)
    }
    
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        withUnsafePointer(to: &model) {
            NKLog("Model has address: \($0)")
        }
        return model.deviceModel.effects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = NKEffectSectionController()
        controller.delegate = self
        return controller
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
