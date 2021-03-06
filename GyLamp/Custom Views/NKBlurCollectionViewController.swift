//
//  NKBlurCollectionViewController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKBlurCollectionViewController: NKBlurViewController, ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        
        adapter.dataSource = self
        adapter.collectionView = collectionView
        
        return adapter;
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        fatalError("This method needs to be overridden")
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        fatalError("This method needs to be overridden")
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    private func configureCollection() {
        
    }
    
}
