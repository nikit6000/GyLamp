//
//  NKVerticalSlider.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKVerticalSlider: UIControl {
    
    // MARK: - vars
    public var value: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    private var oldValue: CGFloat = 0.0
    
    public var sliderColor: UIColor? {
        get {
            slidingView.backgroundColor
        }
        set {
            slidingView.backgroundColor = newValue
        }
    }
    
    private lazy var slidingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var impactGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        return generator
    }()
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
            panGestureRecognizer.translation(in: self).y >= 0
        else {
            return true
        }
        return true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let clampedInversedValue = 1.0 - value.clamp(0.0, 1.0)
        slidingView.frame = CGRect(
            x: .zero,
            y: clampedInversedValue * frame.height,
            width: frame.width,
            height: frame.height
        )
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(slidingView)
        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureRecognizerHandler(_:))
        )
        panGestureRecognizer.delegate = self
        panGestureRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func beginTracking() {
        guard self.isEnabled else { return }
        oldValue = value
        sendActions(for: .touchDown)
    }
    
    private func continueTracking(with translation: CGPoint) {
        guard self.isEnabled else { return }
        
        let newValue: CGFloat = oldValue - translation.y / self.frame.height
        let isNewValueInRange = newValue >= 0 && newValue <= 1.0
        let currentValueInRange = value > 0 && value < 1.0
        
        guard isNewValueInRange || currentValueInRange else { return }
        
        value = newValue.clamp(0.0, 1.0)
        
        if value == 1.0 || value == 0.0 {
            impactGenerator.impactOccurred()
        }
        
        sendActions(for: .valueChanged)
    }
    
    private func endTracking() {
        sendActions(for: .touchUpInside)
    }
    
    // MARK: - actions
    @objc
    private func panGestureRecognizerHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            beginTracking()
        case .changed:
            let translation = gestureRecognizer.translation(in: self)
            continueTracking(with: translation)
        case .ended:
            endTracking()
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NKVerticalSlider: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard
            let view = otherGestureRecognizer.view,
            let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer
        else { return false }
        
        let velocity = panGestureRecognizer.velocity(in: self)
        let isScrollView = view is UIScrollView
        let isHorizontalTranslation = abs(velocity.x) > abs(velocity.y)
        
        return isScrollView && isHorizontalTranslation
    }
}
