//
//  NKSliderController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 27/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKSliderController: ListSectionController {
    
    private(set) var model: NKFloatModel!
    
    public weak var delegate: NKSectionControllerDelegate? = nil
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let size = collectionContext?.containerSize else {
            return CGSize(width: 112, height: 112)
        }
        
        let onScreenCount: CGFloat
        
        if UIScreen.main.scale == 3.0 {
            /* iPhone 7 Plus and above*/
            onScreenCount = 4.0
        } else  {
            onScreenCount = 3.0
        }
        
        return CGSize(width: size.width / onScreenCount - 8.0, height: size.width / onScreenCount - 8.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKSliderCell.self, for: self, at: index) as? NKSliderCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.model = model
        
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
        guard let object = object as? NKFloatModel else {
            fatalError("model must be a NKDeviceModel")
        }
        model = object
        
        self.model.reload = { [weak self] in
            self?.reload()
        }
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didSelect(controller: self, in: self.section, at: index)
    }
    
    
}

