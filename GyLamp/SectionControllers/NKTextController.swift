//
//  NKTextController.swift
//  GyLamp
//
//  Created by Никита on 29/07/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKTextController: ListSectionController {
    
    var model: String?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 80)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKTextCell.self, for: self, at: index) as? NKTextCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.text = model
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? String else {
            fatalError("model must be a String")
        }
        model = object
    }
    
    deinit {
        NKLog("[NKTextController] - deinit")
    }
    
}

