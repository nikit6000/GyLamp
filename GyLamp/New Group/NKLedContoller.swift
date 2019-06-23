//
//  NKLedContoller.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKLedController: NSObject {
    
    public var url: URL
    public var name: String?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
}

extension NKLedController: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return url as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKLedController else {
            return false
        }
        
        return (object.url == self.url)
    }
    
    
}
