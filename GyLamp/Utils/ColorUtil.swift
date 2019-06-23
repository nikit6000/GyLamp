//
//  ColorUtil.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class ColorUtil {
    
    public static let shared = ColorUtil()
    
    public var colorizer: BehaviorRelay<NKColorizer> =  BehaviorRelay(value: NKDefaultColorizer())
    
    public func set(colorizer value: NKColorizer) {
        UIApplication.shared.statusBarStyle = value.statusBarStyle
        colorizer.accept(value)
    }
    
    
    
    
}
