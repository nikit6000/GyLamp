//
//  NKForceGesture.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

// MARK: GestureRecognizer
@available(iOS 9.0, *)
class NKForceGesture: UIGestureRecognizer
{
    let threshold: CGFloat
    
    
    private(set) var progress:CGFloat = 0.0
    
    private var deepPressed: Bool = false
    
    required init(target: AnyObject?, action: Selector, threshold: CGFloat = 0.75)
    {
        self.threshold = threshold
        
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_  touches: Set<UITouch>, with event: UIEvent)
    {
        if let touch = touches.first
        {
            handleTouch(touch: touch)
        }
    }

    override func  touchesMoved(_ touches: Set<UITouch>, with event: UIEvent)
    {
        if let touch = touches.first
        {
            if (touch.maximumPossibleForce != 0) {
                progress = touch.force / (threshold * touch.maximumPossibleForce)
                
                if progress > 1.0 {
                    progress = 1.0
                }
                
            }
            
            handleTouch(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent)
    {
        super.touchesEnded(touches, with: event)
        
        state = deepPressed ? .ended : .failed
        
        deepPressed = false
    }
    
    private func handleTouch(touch: UITouch)
    {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else
        {
            return
        }
        
        if !deepPressed && (touch.force / touch.maximumPossibleForce) >= threshold
        {
            state = .began
            
            deepPressed = true
        }
        else if deepPressed && (touch.force / touch.maximumPossibleForce) < threshold
        {
            state = .ended
            
            deepPressed = false
        }
    }
}
