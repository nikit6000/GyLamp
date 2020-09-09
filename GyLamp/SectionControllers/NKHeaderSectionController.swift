//
//  NKHeaderSectionController.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKHeaderSectionController: ListSectionController {
    
    var model: NKSectionModel?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 50)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKSectionCell.self, for: self, at: index) as? NKSectionCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.model = model
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? NKSectionModel else {
            fatalError("model must be a String")
        }
        model = object
    }
    
    
}
