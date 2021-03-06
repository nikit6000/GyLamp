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

class GLArrayComand<Element: LosslessStringConvertible>: NKStringComand {
    var elements: [Element]
    
    override var comand: String? {
        return elements.map { String($0) }.joined(separator: ",")
    }
    
    init(withElements elements: [Element] = []) {
        self.elements = elements
        super.init()
    }
    
    init(with singleElement: Element) {
        self.elements = [Element](repeating: singleElement, count: 1)
        super.init()
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
    var channel: UInt
    private var _payload: NKStringComand?
    
    override var payload: NKStringComand? {
        return _payload
    }
    
    override var comand: String? {
        return "\(key),\(channel)"
    }
    
    init(channel: UInt, key: String, payload: NKStringComand?) {
        self.channel = channel
        self.key = key
        _payload = payload
        super.init()
    }
    
}
