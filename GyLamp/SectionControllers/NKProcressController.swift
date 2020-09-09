//
//  NKProcressController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKProcressController: ListSectionController {
    
    private(set) var model: NKProgressModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let size = collectionContext?.containerSize else {
            return CGSize(width: 112, height: 112)
        }
        
        let onScreenCount: CGFloat = 3.0
                
        return CGSize(width: size.width / onScreenCount - 8.0, height: size.width / onScreenCount - 8.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKProgressCell.self, for: self, at: index) as? NKProgressCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.maxValue = model.maxValue
        cell.progress = model.value
        
        cell.isLongPressAble = true
        
        return cell
    }
    
    public func reload() {
        let context = self.collectionContext
        
        context?.performBatch(animated: false, updates: { [weak self] updater in
            
            guard let strongSelf = self else {
                return
            }
            
            updater.reload(strongSelf)
        }, completion: nil)
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? NKProgressModel else {
            fatalError("model must be a NKDeviceModel")
        }
        model = object
        
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func didLongPress(item: Int) {
        
    }
    
}

