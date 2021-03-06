//
//  NKEnumSectionModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 07.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKEnumSectionModel: ListDiffable {
    
    var sectionTitle: String
    var titles: [String]
    var items: [Any]
    var icons: [UIImage?]
    var descriptions: [String?]
    
    init(sectionTitle: String, titles: [String] = [], items: [Any] = [], icons: [UIImage?] = [], descriptions: [String?] = []) {
        self.sectionTitle = sectionTitle
        self.titles = titles
        self.items = items
        self.icons = icons
        self.descriptions = descriptions
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return sectionTitle as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    
    
}
