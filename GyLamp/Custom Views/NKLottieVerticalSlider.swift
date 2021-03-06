//
//  NKLottieVerticalSlider.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 13.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import Lottie

class NKLottieVerticalSlider: NKVerticalSlider {
    
    private var animationColor: ColorValueProvider
    
    private lazy var animationView: AnimationView = {
        let view = AnimationView()
        
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        view.loopMode = .playOnce
        view.animationSpeed = 2.0
        
        return view
    }()
    
    public var animation: Animation? {
        get {
            return animationView.animation
        }
        set {
            
            let strokeColorKeyPath = AnimationKeypath(keypath: "**.Stroke 1.Color")
            let fillColorKeyPath = AnimationKeypath(keypath: "**.Fill 1.Color")
            
            animationView.animation = newValue
            
            animationView.setValueProvider(animationColor, keypath: fillColorKeyPath)
            animationView.setValueProvider(animationColor, keypath: strokeColorKeyPath)
            
            animationView.currentFrame = animationView.frameTime(forMarker: valueState.animationMark) ?? 0.0
        }
    }
    
    override var valueState: NKVerticalSliderState {
        didSet {
            
            if oldValue == valueState {
                return
            }
            
            animationView.play(toMarker: valueState.animationMark)
            
        }
    }

    public var iconColor: UIColor {
        didSet {
            animationColor.color = iconColor.lottieColorValue
            animationView.setNeedsDisplay()
        }
    }

    
    override init(frame: CGRect) {
        
   
        self.animationColor = ColorValueProvider(#colorLiteral(red: 0.4156862745, green: 0.4117647059, blue: 0.4156862745, alpha: 1).lottieColorValue)
        self.iconColor = #colorLiteral(red: 0.4156862745, green: 0.4117647059, blue: 0.4156862745, alpha: 1)
        
        super.init(frame: frame)
        
        self.addSubview(animationView)
        
        setupConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupConstarints() {
        
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            animationView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

extension NKVerticalSliderState {
    
    var animationMark: String {
        switch self {
        case .upper:
            return "upperPin"
        case .middle:
            return "middlePin"
        case .lower:
            return "lowerPin"
        case .default:
            return "defaultPin"
        }
    }
    
}
