//
//  NKListRangedModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 07.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import IGListKit

class NKListRangedModel<T: Numeric>: ListDiffable, NKListViewable where T: Comparable, T: Hashable {
    
    private(set) var maxValue: T
    private(set) var minValue: T
    private(set) var format: String
    
    private var internalValue: T
    
    public var title: String
    public var description: String?
    public var icon: UIImage?
    
    public var value: T {
        get {
            return internalValue
        }
        set {
            if (newValue > maxValue) {
                internalValue = maxValue
            } else if (newValue < minValue) {
                internalValue = minValue
            } else {
                internalValue = newValue
            }
        }
    }
    
    init(rangedModel: NKListRangedModel<T>, title: String, icon: UIImage? = nil, description: String? = nil) {
        self.minValue = rangedModel.minValue
        self.maxValue = rangedModel.maxValue
        self.format = rangedModel.format
        self.internalValue = rangedModel.value
        self.title = title
        self.icon = icon
        self.description = description
    }
    
    init(value: T, maxValue: T, minValue: T, format: String = "N/S") {
        self.minValue = minValue
        self.maxValue = maxValue
        self.format = format
        self.internalValue = value
        self.title = ""
        self.description = nil
        self.icon = nil
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        var hasher = Hasher()
        
        hasher.combine(maxValue)
        hasher.combine(minValue)
        hasher.combine(internalValue)
        
        let hash = hasher.finalize()
        
        return hash as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKListRangedModel<T> else {
            return false
        }
        
        return (object.maxValue == self.minValue) && (object.minValue == self.minValue) && (object.value == self.value)
    }
    
}
