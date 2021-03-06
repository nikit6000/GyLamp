//
//  NKThemedWindow.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 21.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import Material

class NKThemedWindow: UIWindow {
    
    private var _useSystemTheme: Bool {
        didSet {
            if (oldValue != _useSystemTheme) {
                UserDefaults.standard.set(!_useSystemTheme, forKey: "GyLamp.useCustomTheme")
                UserDefaults.standard.synchronize()
            }
            
            if #available(iOS 13.0, *), _useSystemTheme {
                self.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
    
    @available(iOS 13.0, *)
    public var useSystemTheme: Bool {
        get {
            return _useSystemTheme
        }
        set {
            _useSystemTheme = newValue
        }
    }
    
    private var indexedTheme: IndexedTheme = .systemLight {
        didSet {
            
            if #available(iOS 13.0, *), _useSystemTheme == false {
                switch indexedTheme {
                case .systemDark:
                    self.overrideUserInterfaceStyle = .dark
                case .systemLight:
                    self.overrideUserInterfaceStyle = .light
                }
            }
            
            Theme.apply(indexedTheme: indexedTheme)
            
        }
    }
    
    @available(iOS 13.0, *)
    override init(windowScene: UIWindowScene) {
        self._useSystemTheme = !UserDefaults.standard.bool(forKey: "GyLamp.useCustomTheme")
        super.init(windowScene: windowScene)
        commonInit()
    }
    
    override init(frame: CGRect) {
        if #available(iOS 13, *) {
            self._useSystemTheme = !UserDefaults.standard.bool(forKey: "GyLamp.useCustomTheme")
        } else {
            self._useSystemTheme = false
        }
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        let themeIndex = UserDefaults.standard.integer(forKey: "GyLamp.themeIndex")
        let indexedTheme = IndexedTheme(rawValue: themeIndex) ?? .systemLight
        
        if #available(iOS 13.0, *) {
            
            if _useSystemTheme {
                applySystemTheme()
            } else {
                self.indexedTheme = indexedTheme
            }
            
        } else {
            self.indexedTheme = indexedTheme
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard #available(iOS 13.0, *) else {
            return
        }
        
        if _useSystemTheme && traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            applySystemTheme()
        }
    }
    
    @available(iOS 13.0, *)
    private func applySystemTheme() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            indexedTheme = .systemDark
        case .light:
            indexedTheme = .systemLight
        default:
            break
        }
    }
    
}
