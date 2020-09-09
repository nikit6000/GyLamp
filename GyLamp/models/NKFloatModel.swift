//
//  NKFloatModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 27/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxRelay

typealias VoidAction = ()->()

class NKFloatModel: NSObject, ListDiffable {

    private(set) var valueRelay: BehaviorRelay<CGFloat>
    
    var value: CGFloat {
        didSet {
            valueRelay.accept(value)
        }
    }
    
    var text: String?

    
    var reload: VoidAction? = nil
    
    init(value: CGFloat, text: String? = nil) {
        
        self.valueRelay = BehaviorRelay(value: value)
        
        self.value = value
        self.text = text
        
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
    
}
