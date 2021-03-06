//
//  NKListViewable.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 18.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

protocol NKListViewable: class {
    associatedtype ValueType

    var value: ValueType { get set }
    
    var title: String { get }
    var description: String? { get }
    var icon: UIImage? { get }
    
}
