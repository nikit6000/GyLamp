//
//  NKSlidersModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

enum NKSliderType: Int {
    case int
    case float
}

class NKSliderModel: NSObject {
    
    private var type: NKSliderType
    
    public var value: CGFloat = 0.0
    public var cmd: String
    
    private(set) var minValue: CGFloat
    private(set) var maxValue: CGFloat

    public weak var model: NKDeviceProtocol?
    
    public var strVal: String {
        
        let value = self.value * (maxValue - minValue) + minValue
        
        switch type {
            case .int:
                return "\(Int(value))"
            case .float:
                return "\(value)"
        }
        
    }
    
    init(cmd: String, min: CGFloat = 0.0, max: CGFloat = 1.0, type: NKSliderType = .float) {
        
        self.cmd = cmd
        self.minValue = min
        self.maxValue = max
        self.type = type
        
        super.init()
    }
    
}

class NKSlidersModel: NSObject {
    
    public var sliders: [NKSliderModel] = []
    
}

extension NKSlidersModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
}

extension NKSliderModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
}
