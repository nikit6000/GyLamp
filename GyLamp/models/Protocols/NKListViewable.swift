//
//  NKListViewable.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 18.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

protocol NKListDisplayable: class {
    var title: String { get set }
    var description: String? { get set }
    var icon: UIImage? { get set }
}

protocol NKListViewable: NKListDisplayable {
    associatedtype ValueType

    var value: ValueType { get set }
}
