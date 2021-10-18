//
//  NKCollectionView.swift
//  GyLamp
//
//  Created by Никита on 10/08/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import Motion

enum NKCollectionSelectAnimation {
    case incSize
    case decSize
}

class NKCollectionView: UICollectionView {
    
    // MARK: - vars
    public weak var nkDelegate: NKCollectionViewDelegate?
    
    public var pressDuration: TimeInterval = Constants.defaultLongPressDuration {
        didSet {
            longPressGesture.minimumPressDuration = pressDuration
        }
    }
    
    private var afterItems: [UITouch: DispatchWorkItem] = [:]
    private var lastTapCells: [UITouch: UICollectionViewCell] = [:]
    private var isLongPressRecognized: Bool = false
    private let minimalScaleFactor: CGFloat = 0.85
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onGesture(recognizer:)))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.minimumPressDuration = 0.3
        return gestureRecognizer
    }()
    
    // MARK: - initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods
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
        if isLongPressRecognized {
            isLongPressRecognized = false
            touchesCancelled(touches, with: event)
        } else {
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            releaseItem(for: touch)
        }
        super.touchesCancelled(touches, with: event)
    }
    
    private func setupUI() {
        delaysContentTouches = true
        allowsMultipleSelection = false
        addGestures()
    }
    
    private func addGestures() {
        addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func onGesture(recognizer: UIGestureRecognizer) {
        
        guard let indexPath = indexPathForItem(at: recognizer.location(in: self)), let cell = cellForItem(at: indexPath) else {
            return
        }
        
        guard isSupportLongPress(cell: cell) == true else {
            return
        }
        
        switch recognizer.state {
            
        case .began:
            isLongPressRecognized = true
            nkDelegate?.collectionView?(self, didSelectExtendedItemAt: indexPath)
        default:
            break
        }
    }
    
    private func isSupportLongPress(cell: UICollectionViewCell) -> Bool {
        guard let cell = cell as? NKPressableCellProtocol else {
            return false
        }
        return cell.isLongPressAble
    }
    
    private func canHandle(cell: UICollectionViewCell) -> Bool {
        return (cell as? NKPressableCellProtocol) != nil
    }
    
    private func pressItem(for touch: UITouch) {
        guard
            let indexPath = indexPathForItem(at: touch.location(in: self)),
            let cell = cellForItem(at: indexPath) as? NKPressableCellProtocol
        else { return }
        cell.beginPressing()
    }
    
    private func releaseItem(for touch: UITouch) {
        guard
            let indexPath = indexPathForItem(at: touch.location(in: self)),
            let cell = cellForItem(at: indexPath) as? NKPressableCellProtocol
        else { return }
        cell.endPressing()
    }
    
    private func makeImpact() {
        let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactGenerator.prepare()
        impactGenerator.impactOccurred()
    }
}

// MARK: - constants
private extension NKCollectionView {
    struct Constants {
        static let minimumShrinkingScale: CGFloat = 0.9
        static let defaultLongPressDuration: TimeInterval = 0.3
        static let shrinkingAnimationDuration: TimeInterval = 0.3
        static let shrinkingAnimationDelay: TimeInterval = 0.05
        static let shrinkingAnimationKey = "shrinkAnimation"
    }
}
