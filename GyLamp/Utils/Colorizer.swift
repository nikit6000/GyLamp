//
//  Colorizer.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

enum NKColorizerItem {
    case primary
    case collectionBackground
    case collectionCells
    case hairline
    case sections
    case sectionText
}

class NKColorizer {
    
    fileprivate(set) var palette : [NKColorizerItem : UIColor]
    fileprivate(set) var barStyle: UIBarStyle
    fileprivate(set) var statusBarStyle: UIStatusBarStyle
    
    init() {
        palette = [:]
        barStyle = .default
        statusBarStyle = .default
    }
    
}

class NKDefaultColorizer : NKColorizer {
    
    override init() {
        super.init()
        palette = [ .primary: .white,
                    .collectionBackground: #colorLiteral(red: 0.8701183823, green: 0.8701183823, blue: 0.8701183823, alpha: 1),
                    .collectionCells: .white,
                    .hairline: .black,
                    .sections: #colorLiteral(red: 0.8701183823, green: 0.8701183823, blue: 0.8701183823, alpha: 1),
                    .sectionText: .gray]
        barStyle = .default
        statusBarStyle = .default
    }
    
}
