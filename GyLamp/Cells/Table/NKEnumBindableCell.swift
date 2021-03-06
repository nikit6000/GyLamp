//
//  NKEnumBindableCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 07.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKEnumBindableCell: NKStringConvertableParamCell {
    
    override func bindViewModel(_ viewModel: Any) {
        guard let model = viewModel as? ListEnumICModel else { return }
        
        self.image = model.icon
        self.title = model.title
        self.subtitle = nil
        self.isImageRounded = false
        self.param = model.value.description
        
    }
    
}
