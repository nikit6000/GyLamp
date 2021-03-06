//
//  ListEnumICModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

protocol ListEnumStringConvertable {
    
    var rawValue: Int16 { get }
    var description: String { get }
    var allCasesAsString: [String] { get }
    var allCasesRawValue: [Int16] { get }
    
    init?(rawValue: Int16)
}

class ListEnumICModel: ListDiffable, NKListViewable {
    
    var value: ListEnumStringConvertable
    
    private(set) var title: String
    private(set) var icon: UIImage?
    private(set) var description: String?
    
    public var casesDescriptions: [String] {
        return value.allCasesAsString
    }
    
    init(title: String, value: ListEnumStringConvertable, description: String?, icon: UIImage? = nil) {
        self.value = value
        self.title = title
        self.description = description
        self.icon = icon
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return value as! NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        guard let object = object as? ListEnumICModel else {
            return false
        }
        
        return object.value.rawValue == object.value.rawValue
        
    }
    
    
}
