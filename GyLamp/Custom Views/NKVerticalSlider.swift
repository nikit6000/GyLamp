//
//  NKVerticalSlider.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKVerticalSlider: UIControl {
    
    private var lastTapLocation: CGPoint
    private var oldValue: CGFloat
    private var isVerticalPan = true
    
    
    private var sliderLayer: NKSliderLayer {
        return layer as! NKSliderLayer
    }
    
    override class var layerClass: AnyClass {
        return NKSliderLayer.self
    }
    
    public var value: CGFloat {
        didSet {
            
            if value > 1.0 {
                sliderLayer.value = 1.0
            } else if value < 0.0 {
                sliderLayer.value = 0.0
            } else {
                sliderLayer.value = value
            }
            
            sliderLayer.setNeedsDisplay()
        }
    }
    
    public var sliderColor: UIColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        self.lastTapLocation = .zero
        self.value = 0.0
        self.oldValue = 0.0
        self.sliderColor = .white
        
        super.init(frame: frame)
        
        
        
        sliderLayer.setNeedsDisplay()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
     
     guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
     return super.gestureRecognizerShouldBegin(gestureRecognizer)
     }
     
     let velocity = panGesture.velocity(in: self)
     NKLog(velocity)
     
     return abs(velocity.y) > abs(velocity.x)
     }*/
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let result = super.beginTracking(touch, with: event)
        
        if self.isEnabled == false {
            return result
        }
        
        lastTapLocation = touch.location(in: self)
        oldValue = value
        sendActions(for: .touchDown)
        return result
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.continueTracking(touch, with: event)
        
        let deltaY = lastTapLocation.y - touch.location(in: self).y
        let newValue: CGFloat = oldValue + deltaY / self.frame.height
        
        if self.isEnabled == false {
            return result
        }
        
        if newValue > 1.0 {
            value = 1.0
        } else if newValue < 0 {
            value = 0
        } else {
            value = newValue
        }
        
        sendActions(for: .valueChanged)
        
        //NKLog(value)
        return result
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        sendActions(for: .touchUpInside)
    }
    
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == #keyPath(NKSliderLayer.value),
            let action = super.action(for: layer, forKey: #keyPath(backgroundColor)) as? CAAnimation,
            let animation: CABasicAnimation = (action.copy() as? CABasicAnimation) {
            
            animation.keyPath = #keyPath(NKSliderLayer.value)
            animation.fromValue = sliderLayer.value
            animation.toValue = value
            self.layer.add(animation, forKey: #keyPath(NKSliderLayer.value))
            
            return animation
        }
        
        return super.action(for: layer, forKey: event)
    }
    
}

fileprivate class NKSliderLayer: CALayer {
    @NSManaged var value: CGFloat
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(value) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        
        
        
        let height = value * self.frame.height
        let width = self.frame.width
        let y = self.frame.height - height
        
        let frame = CGRect(x: 0, y: y, width: width, height: height)
        
        UIColor.black.setFill()
        ctx.fill(self.bounds)
        
        UIColor.white.setFill()
        ctx.fill(frame)
        
        UIGraphicsPopContext()
    }
}
