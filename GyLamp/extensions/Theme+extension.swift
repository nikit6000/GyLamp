//
//  Theme+extension.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 20.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import Material

enum IndexedTheme: Int {
    case systemLight = 0
    case systemDark = 1
}

extension Theme {
    
    static private var themes: [IndexedTheme: Theme] = [
        .systemDark: .systemDark,
        .systemLight: .systemLight
    ]
    
    static var systemLight: Theme {
        var theme = Theme()
        
        theme.background = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        theme.primary = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        theme.secondary = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
        theme.error = #colorLiteral(red: 0.9411764706, green: 0.05882352941, blue: 0, alpha: 1)
        
        theme.onBackground = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.onPrimary = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.onSecondary = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        theme.onError = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return theme
    }
    
    static var systemDark: Theme {
        var theme = Theme()
        
        theme.background = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.primary = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        theme.secondary = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1803921569, alpha: 1)
        theme.error = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        
        theme.onBackground = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theme.onPrimary = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        theme.onSecondary = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        theme.onError = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return theme
    }
    
    static func apply(indexedTheme: IndexedTheme) {
        guard let theme = themes[indexedTheme] else {
            fatalError("No theme for index")
        }
        self.apply(theme: theme)
    }
}

