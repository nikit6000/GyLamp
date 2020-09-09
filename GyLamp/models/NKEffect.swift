//
//  NKEffect.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxRelay
import RxSwift

class NKEffect: NSObject, ListDiffable {
    
    private(set) var mode: String
    
    public var isSet: Bool
    public var isLoading: Bool
    public var hasError: Bool
    
    public weak var deviceModel: NKDeviceProtocol?
    
    init(mode: String) {
        self.mode = mode
        
        self.isSet = false
        self.isLoading = false
        self.hasError = false
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
    
}


class NKEffects: NSObject {
    
    public var models: [NKEffect] = []
    
}

extension NKEffects: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
}
