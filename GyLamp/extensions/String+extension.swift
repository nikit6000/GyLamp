//
//  String+extension.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 20.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
