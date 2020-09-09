//
//  NKProgressModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKProgressModel: NSObject, ListDiffable {
    
    public var maxValue: CGFloat
    public var value: CGFloat
    
    init(maxValue: CGFloat = 255, value: CGFloat = 0) {
        
        self.maxValue = maxValue
        self.value = value
        
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
}
