//
//  NKWideRangePicker.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 18.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import Material

protocol NKWideRangePickable: Numeric, Comparable, LosslessStringConvertible {
    static var isFloatingPoint: Bool { get }
    static var isSigned: Bool { get }
    static var absoluteMaximum: Self? { get }
}

extension UIAlertController {
    
    /// Add a textField
    ///
    /// - Parameters:
    ///   - height: textField height
    ///   - hInset: right and left margins to AlertController border
    ///   - vInset: bottom margin to button
    ///   - configuration: textField
    
    func addWideRangePicker<T: NKWideRangePickable>(configuration: NKWideRangePickerViewController<T>.Config?, min: T? = nil, max: T? = nil, handler: NKWideRangePickerViewController<T>.Action? = nil) {
        let textField = NKWideRangePickerViewController<T>(configuration: configuration, action: handler, min: min, max: max)
        let height: CGFloat = 80.0
        set(vc: textField, height: height)
    }
}

final class NKWideRangePickerViewController<T: NKWideRangePickable>: NKStringValuePicker {
    
    typealias Config = (_ textField: Material.ErrorTextField) -> ()
    typealias Action = (_ textField: Material.ErrorTextField, _ value: T) -> ()
    
    private var min: T?
    private var max: T?
    private var action: Action?
    
    init(configuration: Config?, action: Action?, min: T? = nil, max: T? = nil) {
        self.min = min
        self.max = max
        self.action = action
        
        if (max < min) {
            fatalError("Maximum value must be greater than minimum value")
        }
        
        super.init(configuration: configuration, action: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var allowedCharacters = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: string)
        
        var signCount: Int = (textField.text?.first == "-") ? 1 : 0
        var lastSignOffset: Int = 0
        var pointCount: Int = (textField.text?.firstIndex(of: ".") != nil) ? 1 : 0
        
        string.enumerated().forEach {
            if $0.element == "-" {
                signCount += 1
                lastSignOffset = $0.offset
            } else if $0.element == "." {
                pointCount += 1
            }
        }
        
        
        if T.isSigned && signCount == 1 && range.lowerBound == lastSignOffset {
            allowedCharacters.insert("-")
        }
        
        if T.isFloatingPoint && pointCount == 1 {
            allowedCharacters.insert(".")
        }
        
        return allowedCharacters.isSuperset(of: inputCharacterSet)
        
    }
    
    override func onTextChanged(_ sender: ErrorTextField) {
        guard let textValue = sender.text else {
            
            sender.error = NSLocalizedString("WideRangePicker.error.noValue", comment: "")
            sender.shake(with: .error)
            sender.isErrorRevealed = true
            
            return
        }
        
        let numericValue = T(textValue)
        
        let normalizedValue: T?
        let error: String?
        
        if numericValue == nil {
            error = NSLocalizedString("WideRangePicker.error.cantConvert", comment: "")
            normalizedValue = nil
        } else if let min = self.min, numericValue! < min {
            let format = NSLocalizedString("WideRangePicker.error.lower.fmt", comment: "")
            
            error = String(format: format, "\(min)")
            normalizedValue = min
        } else if let max = self.max, numericValue! > max {
            let format = NSLocalizedString("WideRangePicker.error.greater.fmt", comment: "")
            
            error = String(format: format, "\(max)")
            normalizedValue = max
        } else {
            error = nil
            normalizedValue = numericValue!
            sender.isErrorRevealed = false
        }
        
        if error != nil {
            sender.error = error
        
            if !sender.isErrorRevealed {
                sender.isErrorRevealed = true
                sender.shake(with: .error)
            }
        } else {
            action?(sender, normalizedValue!)
            sender.isErrorRevealed = false
        }
    }
    
}


extension Float: NKWideRangePickable {
    
    static var isSigned: Bool { true }
    static var isFloatingPoint: Bool { true }
    static var absoluteMaximum: Float? { nil }
}

extension UInt32: NKWideRangePickable {
    static var isSigned: Bool { false }
    static var isFloatingPoint: Bool { false }
    static var absoluteMaximum: UInt32? { UInt32.max }
}

extension UInt16: NKWideRangePickable {
    static var isSigned: Bool { false }
    static var isFloatingPoint: Bool { false }
    static var absoluteMaximum: UInt16? { UInt16.max }
}

extension Int16: NKWideRangePickable {
    static var isSigned: Bool { true }
    static var isFloatingPoint: Bool { false }
    static var absoluteMaximum: Int16? { Int16.max }
}
