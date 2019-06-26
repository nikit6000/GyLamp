//
//  NKEffect.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKEffect: NSObject, ListDiffable {
    
    private(set) var mode: NKDeviceMode
    
    public var speed: Float = 0.5
    public var scale: Float = 0.3
    public var brightness: Float = 1.0
    
    public var isSet: Bool = false
    
    init(mode: NKDeviceMode) {
        self.mode = mode
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKEffect else {
            return false
        }
        
        return  (self.speed == object.speed) &&
                (self.scale == object.scale) &&
                (self.brightness == object.brightness)
    }
    
    
}
