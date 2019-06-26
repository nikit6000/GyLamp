//
//  NKSectionModel.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

enum NKSectionStyle {
    case top
    case bottom
}

class NKSectionModel: NSObject {
    
    public var title: String?
    public var style: NKSectionStyle
    
    public var isLoading: Bool
    
    init(style: NKSectionStyle, title: String? = nil) {
        self.title = title
        self.style = style
        self.isLoading = false
        super.init()
    }
    
}

extension NKSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKSectionModel else {
            return false
        }
        
        return (object.title == self.title) && (object.style == self.style)
    }
    
}
