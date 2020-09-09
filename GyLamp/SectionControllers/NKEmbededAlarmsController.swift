//
//  NKEmbededAlarmsController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

class NKEmbededAlarmsController: ListSectionController {
    
    var model: NKAlarmsModel?
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
        
        cell.collectionView.nkDelegate = self
        
        self.adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let model = object as? NKAlarmsModel else {
            return
        }
        self.model = model
        self.adapter.reloadData(completion: nil)
    }
    
    deinit {
        NKLog("[NKEmbededAlarmsController] - deinit")
    }
    
}

extension NKEmbededAlarmsController: ListAdapterDataSource, NKCollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectExtendedItemAt indexPath: IndexPath) {
        let sectionController = adapter.sectionController(forSection: indexPath.section)
        sectionController?.didLongPress(item: indexPath.item)
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return model?.alarmModels ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return NKAlarmSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
