//
//  NKCollectionView.swift
//  GyLamp
//
//  Created by Никита on 10/08/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

enum NKCollectionSelectAnimation {
    case incSize
    case decSize
}

class NKCollectionView: UICollectionView {

    private var longPressGesture: UILongPressGestureRecognizer!

    private var afterItems: [UITouch: DispatchWorkItem] = [:]
    private var lastTapCells: [UITouch: UICollectionViewCell] = [:]
    private var isForceRecognized: Bool = false
    
    //private let forceThreshold: CGFloat = 0.2
    private let minimalScaleFactor: CGFloat = 0.85
    
    
    public weak var nkDelegate: NKCollectionViewDelegate?
    
    public var pressDuration: TimeInterval {
        set {
            longPressGesture.minimumPressDuration = newValue
        }
        get {
            return longPressGesture.minimumPressDuration
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(NKCollectionView.onGesture(recognizer:)))
        longPressGesture.cancelsTouchesInView = false
        longPressGesture.minimumPressDuration = 0.5
        
        self.delaysContentTouches = true
    
        addGestures()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGestures() {
        
        self.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc private func onGesture(recognizer: UIGestureRecognizer) {
        
        guard let indexPath = self.indexPathForItem(at: recognizer.location(in: self)), let cell = self.cellForItem(at: indexPath) else {
            return
        }
        
        guard isSupportLongPress(cell: cell) == true else {
            return
        }
        
        switch recognizer.state {
            
        case .began:
            reset(cell: cell)
            isForceRecognized = true
            nkDelegate?.collectionView?(self, didSelectExtendedItemAt: indexPath)
        default:
            break
        }
        
    
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            pressItem(for: touch)
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first {
            releaseItem(for: touch)
        }
        
        if !isForceRecognized {
            super.touchesEnded(touches, with: event)
        }
        
        isForceRecognized = false
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            releaseItem(for: touch)
        }
        
        isForceRecognized = false
        
        super.touchesCancelled(touches, with: event)
        
    }
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        
        return super.touchesShouldBegin(touches, with: event, in: view)
        
    }
    
    
    private func isSupportLongPress(cell: UICollectionViewCell) -> Bool {
        guard let cell = cell as? NKViewPressAble else {
            return false
        }
        
        return cell.isLongPressAble
    }
    
    private func canHandle(cell: UICollectionViewCell) -> Bool {
        return (cell as? NKViewPressAble) != nil
    }
    
    private func pressItem(for touch: UITouch) {
        
        let timing: TimeInterval = 0.1
        
        let location = touch.location(in: self)
    
        if let indexPath = self.indexPathForItem(at: location), let cell = self.cellForItem(at: indexPath) {
            
            guard canHandle(cell: cell) else {
                return
            }
            
            lastTapCells[touch] = cell
            
            UIView.animate(withDuration: timing, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                cell.transform = CGAffineTransform(scaleX: strongSelf.minimalScaleFactor, y: strongSelf.minimalScaleFactor)
            })
            
            if !isSupportLongPress(cell: cell) {
                return
            }
            
            if #available(iOS 10.0, *) {
                if self.traitCollection.forceTouchCapability == .available {
                    return
                }
            }
            
            let dispatchItem = DispatchWorkItem(block: { [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                UIView.animate(withDuration: strongSelf.pressDuration - timing, delay: 0, options: .curveLinear, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                })
            })
            
            afterItems[touch] = dispatchItem
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timing, execute: dispatchItem);

        }
    }
    
    private func releaseItem(for touch: UITouch) {
        
        if let task = afterItems[touch] {
            task.cancel()
            afterItems[touch] = nil
        }
        
        guard let cell = lastTapCells[touch] else {
            return
        }
        
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = .identity
        })
        
    }
    
    private func reset(cell: UICollectionViewCell) {
        
        makeImpact()
        
        cell.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 20, options: .curveEaseInOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
    
    private func makeImpact() {
        
        if #available(iOS 10.0, *) {
            let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactGenerator.prepare()
            impactGenerator.impactOccurred()
        }
        
    }
    
    
    
}
