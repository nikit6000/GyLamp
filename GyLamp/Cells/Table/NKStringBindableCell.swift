//
//  NKStringBindableCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.03.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit

class NKStringBindableCell: NKStringConvertableParamCell {
    
    override func bindViewModel(_ viewModel: Any) {
        guard let model = viewModel as? NKStringListModel else {
            return
        }
        
        let text: String
        
        if model.isSequreEntry {
            text = String(repeating: "•", count: model.value.count)
        } else {
            text = model.value
        }
        
        self.image = model.icon
        self.title = model.title
        self.subtitle = nil
        self.isImageRounded = false
        self.param = text
    }
    
}
