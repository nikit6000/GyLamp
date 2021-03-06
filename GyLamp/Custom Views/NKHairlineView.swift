//
//  HairlineView.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

enum NKHairlineStyle {
    case top
    case bottom
}

class NKHairlineView: UIView {
    
    private var mHairlineColor: UIColor?
    private var mHairlineAlpha: CGFloat
    private var mStyle: NKHairlineStyle
    
    public var hairlineColor: UIColor? {
        set {
            mHairlineColor = newValue
            self.setNeedsDisplay()
        }
        get {
            return mHairlineColor
        }
    }
    
    public var hairlineAlpha: CGFloat {
        set {
            mHairlineAlpha = newValue
            self.setNeedsDisplay()
        }
        get {
            return mHairlineAlpha
        }
    }
    
    public var style: NKHairlineStyle {
        set {
            mStyle = newValue
            self.setNeedsDisplay()
        }
        get {
            return mStyle
        }
    }
    
    init(style: NKHairlineStyle) {
        mStyle = style
        mHairlineAlpha = 0.3
        mHairlineColor = .black
        
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        
        mStyle = .bottom
        mHairlineAlpha = 0.3
        mHairlineColor = .black
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let tickness = UIScreen.main.hairlineTickness
        
        let y = (mStyle == .bottom) ? (frame.height - tickness) : 0
        
        context.setLineWidth(tickness)
        //context.translateBy(x: 0, y: 0.5)
        
        if let fillColor = hairlineColor?.withAlphaComponent(mHairlineAlpha).cgColor {
            context.setFillColor(fillColor)
        } else {
            context.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
        }
        
        context.fill(CGRect(x: 0, y: y, width: frame.width, height: tickness))
    }
    
}
