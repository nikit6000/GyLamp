//
//  NKDeviceController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit


class NKDeviceController: ListSectionController {
    
    private var model: NKDeviceModel!
    
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
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKDeviceCell.self, for: self, at: index) as? NKDeviceCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.model = model
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? NKDeviceModel else {
            fatalError("model must be a NKDeviceModel")
        }
        model = object
    }
    
    
}
