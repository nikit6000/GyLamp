//
//  NKDiscreteRangedCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 18.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKDiscreteRangedCell<T: BinaryInteger>: NKNumericParamBindableCell<T> where T: CVarArg {
    
    override func bindViewModel(_ viewModel: Any) {
        guard let model = viewModel as? NKDiscreteRangedModel<T> else { return }
        
        self.image = model.icon
        self.title = model.title
        self.subtitle = nil
        self.isImageRounded = false
        self.param = String(format: model.format, model.value)
        
    }
    
}
