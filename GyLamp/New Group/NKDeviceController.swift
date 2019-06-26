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
    
    
    
    override init() {
        inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let size = collectionContext?.containerSize else {
            return CGSize(width: 112, height: 112)
        }
        return CGSize(width: size.width / 3.0, height: size.width / 3.0)
    }
    
    
    
    
}
