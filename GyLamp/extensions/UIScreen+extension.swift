//
//  UIScreen+extension.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

extension UIScreen {
    
    func getHairlineTickness() -> CGFloat {
        return 1.0 / scale;
    }
    
    var hairlineTickness: CGFloat {
        get {
            return getHairlineTickness()
        }
    }
    
}
