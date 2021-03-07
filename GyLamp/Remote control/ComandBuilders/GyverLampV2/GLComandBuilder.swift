//
//  GLComandBuilder.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 31.01.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

enum GLComandType: UInt {
    case control = 0
    case config = 1
    case effects = 2
    case dawn = 3
}

class GLArrayComand: NKStringComand {
    var elements: [LosslessStringConvertible]
    
    override var comand: String? {
        return elements.map { $0.description }.joined(separator: ",")
    }
    
    init(withElements elements: [LosslessStringConvertible] = []) {
        self.elements = elements
        super.init()
    }
    
    init(with singleElement: LosslessStringConvertible) {
        self.elements = [LosslessStringConvertible](repeating: singleElement, count: 1)
        super.init()
    }
    
    func append(_ element: LosslessStringConvertible) {
        elements.append(element)
    }
    
    func append(contentsOf array: [LosslessStringConvertible]) {
        elements.append(contentsOf: array)
    }
    
}

class GLComand: NKStringComand {
    
    var type: GLComandType
    
    override var comand: String? {
        return "\(type.rawValue)"
    }
    
    init(type: GLComandType) {
        self.type = type
        super.init()
    }
}

class GLComandFrame: NKStringComand {
    
    
    var key: String
    private var _payload: NKStringComand?
    
    override var payload: NKStringComand? {
        return _payload
    }
    
    override var comand: String? {
        return "\(key)"
    }
    
    init(key: String = "GL", payload: NKStringComand?) {
        self.key = key
        _payload = payload
        super.init()
    }
    
}
