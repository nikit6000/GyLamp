//
//  NKSectionDataChangedDelegate.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import IGListKit

@objc protocol NKSectionDataChangedDelegate: class {
    
    @objc optional func sectionController(_ controller: ListSectionController, willUpdate value: Any, at index: Int)
    @objc optional func sectionController(_ controller: ListSectionController, didUpdate value: Any, at index: Int)
    
}
