//
//  NKDiscreteRangedModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 18.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKDiscreteRangedModel<T: BinaryInteger>: ListDiffable, NKListViewable {
     
    public var value: T
    
    private(set) var title: String
    private(set) var description: String?
    private(set) var icon: UIImage?
    private(set) var min: T
    private(set) var max: T
    private(set) var step: T.Stride
    
    private(set) var format: String
    
    public var values: [T] {
        return [T](stride(from: min, through: max, by: step))
    }
    
    public var formattedValues: [String] {
        return values.map { String(format: format, Int($0)) }
    }
    
    init(value: T, from min: T, to max: T, step: T.Stride = 1, format: String = "%d") {
        self.value = value
        self.max = max
        self.min = min
        self.step = step
        self.format = format
        self.title = ""
        self.description = nil
        self.icon = nil
    }
    
    init(from model: NKDiscreteRangedModel<T>, title: String, description: String? = nil, icon: UIImage? = nil) {
        self.value = model.value
        self.max = model.max
        self.min = model.min
        self.step = model.step
        self.format = model.format
        self.title = title
        self.description = description
        self.icon = icon
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        var hasher = Hasher()
        hasher.combine(value)
        hasher.combine(min)
        hasher.combine(max)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(icon)
        return hasher.finalize() as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKDiscreteRangedModel<T> else {
            return false
        }
        
        return object.value == self.value && object.min == self.min && object.max == self.max && object.step == self.step && object.title == self.title && object.description == self.description
    }
    
    
    
    
}
