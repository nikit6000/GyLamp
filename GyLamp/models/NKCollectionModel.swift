//
//  NKCollectionModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

class NKCollectionModel: NSObject, ListDiffable {
    
    var deviceModel: NKDeviceModel
    
    var sectionController: ListSectionController
    
    init(model: NKDeviceModel, controller: ListSectionController) {
        self.deviceModel = model
        self.sectionController = controller
        withUnsafePointer(to: &deviceModel) {
            NKLog("In model pointer", $0)
        }
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
    
}
