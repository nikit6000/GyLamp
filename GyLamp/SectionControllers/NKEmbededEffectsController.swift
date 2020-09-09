//
//  NKEmbededEffectsController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

class NKEmbededEffectsController: ListSectionController {
    
    var model: NKEffects?
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
        
        let onScreenCount: CGFloat = 3.3
    
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
        guard let model = object as? NKEffects else {
            return
        }
        self.model = model
        self.adapter.reloadData(completion: nil)
        
        
    }
    
    deinit {
        NKLog("[NKEmbededEffectsController] - deinit")
    }
    
}

extension NKEmbededEffectsController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.model?.models ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = NKEffectSectionController()
        return controller
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
