//
//  Dictionary+HashableType.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

struct HashableType<T> : Hashable {
    
    static func == (lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.base == rhs.base
    }

    let base: T.Type

    init(_ base: T.Type) {
        self.base = base
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(base))
    }

}

extension Dictionary {
    subscript<T>(key: T.Type) -> Value? where Key == HashableType<T> {
        get { return self[HashableType(key)] }
        set { self[HashableType(key)] = newValue }
    }
}
