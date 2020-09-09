//
//  NKEmbededSlidersController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

class NKEmbededSlidersController: ListSectionController {
    
    private var model: NKSlidersModel? = nil
    
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        return adapter
    }()
    
    override init() {
        
        
        super.init()
    }

    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = collectionContext!.containerSize
        
        
        return CGSize(width: size.width, height: 280)
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: NKSlidersCollectionCell.self, for: self, at: index) as? NKSlidersCollectionCell else {
            fatalError()
        }
        
        self.adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let model = object as? NKSlidersModel else {
            return
        }
        
        self.model = model
        
        self.adapter.reloadData(completion: nil)
        
        //let deviceModel = self.model.deviceModel
        
        
    }
    
    deinit {
        NKLog("[NKEmbededSlidersController] - deinit")
    }
    
}

extension NKEmbededSlidersController: ListAdapterDataSource{
    

    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (model?.sliders as [ListDiffable]?) ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return NKLampSliderController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}

extension NKEmbededSlidersController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
