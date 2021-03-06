//
//  NKVerticalSlider.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

enum NKVerticalSliderState: CGFloat {
    case upper = 1.0
    case middle = 0.5
    case lower = 0.1
    case `default` = 0.0
    
    static func from(value: CGFloat) -> NKVerticalSliderState {
        if (value >= 1.0) {
            return .upper
        } else if (value >= 0.5) {
            return .middle
        } else if (value == 0.0) {
            return .default
        } else {
            return .lower
        }
    }
}

class NKVerticalSlider: UIControl {
    
    private var lastTapLocation: CGPoint
    private var oldValue: CGFloat
    private var isVerticalPan = true
    
    private var barHeightConstraint: NSLayoutConstraint!
    
    private lazy var impactGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        return generator
    }()
    
    private lazy var effectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        view.contentView.addSubview(barView)
        
        return view
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        view.alpha = 0.9
        view.backgroundColor = .white
        
        return view
    }()
    
    public var valueState: NKVerticalSliderState
    
    public var value: CGFloat {
        didSet {
            
            let normalizedValue: CGFloat
            
            if value >= 1.0 && oldValue < 1.0 {
                normalizedValue = 1.0
                impactGenerator.impactOccurred()
            } else if value <= 0.0 && oldValue > 0.0 {
                normalizedValue = 0.0
                impactGenerator.impactOccurred()
            } else {
                normalizedValue = value
            }
            
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            valueState = .from(value: value)
        }
    }
    
    public var sliderOpacity: CGFloat {
        get {
            barView.alpha
        }
        set {
            barView.alpha = newValue
        }
    }
    
    public var sliderColor: UIColor? {
        get {
            barView.backgroundColor
        }
        set {
            barView.backgroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        self.lastTapLocation = .zero
        self.value = 0.0
        self.oldValue = 0.0
        self.valueState = .default
        
        super.init(frame: frame)

        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        self.isMultipleTouchEnabled = false
        self.backgroundColor = .clear
        self.insertSubview(effectView, at: 0)
        
        setupConstarints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let result = super.beginTracking(touch, with: event)
        
        if self.isEnabled == false {
            return result
        }
        
        sendActions(for: .touchDown)
        
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
 
        return result
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        sendActions(for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.squircle()
        barHeightConstraint.constant = value * effectView.frame.height
    }
    
    private func setupConstarints() {
        
        barHeightConstraint = barView.heightAnchor.constraint(equalToConstant: 0.0)
        
        NSLayoutConstraint.activate([
            effectView.widthAnchor.constraint(equalTo: self.widthAnchor),
            effectView.heightAnchor.constraint(equalTo: self.heightAnchor),
            effectView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            effectView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            barView.bottomAnchor.constraint(equalTo: effectView.contentView.bottomAnchor),
            barView.leadingAnchor.constraint(equalTo: effectView.contentView.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: effectView.contentView.trailingAnchor),
            barHeightConstraint
        ])
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
}

