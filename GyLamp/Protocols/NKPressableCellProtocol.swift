//
//  NKPressableCellProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

protocol NKPressableCellProtocol: UICollectionViewCell {
    
    var isPressAble: Bool { get }
    var isLongPressAble: Bool { get }
    
    func beginPressing()
    func endPressing()
}

extension NKPressableCellProtocol {
    
    func pauseAnimation(){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func beginPressing() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = Constants.minimumShrinkingScale
        animation.duration = Constants.shrinkingAnimationDuration
        animation.timingFunction = .easeOut
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        layer.add(animation, forKey: Constants.shrinkingAnimationKey)
    }
    
    func endPressing() {
        guard let transform = layer.presentation()?.transform else { return }
        
        layer.transform = transform
        layer.removeAnimation(forKey: Constants.shrinkingAnimationKey)
        
        UIView.animate(
            withDuration: Constants.shrinkingAnimationDuration,
            delay: .zero,
            usingSpringWithDamping: Constants.reverseAnimationDamping,
            initialSpringVelocity: .zero
        ) {
            self.layer.transform = CATransform3DIdentity
        }
    }
}

// MARK: - constants
private extension UICollectionViewCell {
    struct Constants {
        static let minimumShrinkingScale: CGFloat = 0.9
        static let shrinkingAnimationDuration: TimeInterval = 0.3
        static let shrinkingAnimationDelay: TimeInterval = 0.05
        static let shrinkingAnimationKey = "shrinkAnimation"
        static let reverseAnimationDamping: CGFloat = 0.4
    }
}
