//
//  NKBoolListMoldel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 14.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKBoolListMoldel: ListDiffable, NKListViewable {
    
    public var value: Bool
    public var title: String
    public var description: String?
    public var icon: UIImage?
    
    init(value: Bool, title: String, icon: UIImage? = nil, description: String? = nil) {
        self.value = value
        self.title = title
        self.description = description
        self.icon = icon
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        var hasher = Hasher()
        hasher.combine(value)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(icon)
        return hasher.finalize() as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKBoolListMoldel else {
            return false
        }
        
        return object.title == self.title && object.value == self.value && object.description == self.description
    }
    
    
}
