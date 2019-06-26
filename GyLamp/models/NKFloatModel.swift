//
//  NKFloatModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 27/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKFloatModel: NSObject, ListDiffable {
    
    var value: CGFloat
    var text: String?
    
    init(value: CGFloat, text: String? = nil) {
        self.value = value
        self.text = text
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
    
}
