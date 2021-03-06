//
//  NKNumericParamBindableCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 07.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKNumericParamBindableCell<T: Numeric>: NKStringConvertableParamCell where T: Comparable, T: Hashable, T: CVarArg {
    
    override func bindViewModel(_ viewModel: Any) {
        guard let model = viewModel as? NKListRangedModel<T> else { return }
        
        self.image = model.icon
        self.title = model.title
        self.subtitle = nil
        self.isImageRounded = false
        self.param = String(format: model.format, model.value)
        
    }
    
}
