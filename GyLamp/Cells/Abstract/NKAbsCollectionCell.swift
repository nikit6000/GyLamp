//
//  NKAbsCollectionCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Material
import UIKit

class NKAbsCollectionCell: UICollectionViewCell, Themeable {
     
    var isThemingEnabled: Bool = true
    
    public var isHighlightEnabled: Bool {
        return true
    }
    
    override var isHighlighted: Bool {
        didSet {
            
            guard isHighlightEnabled == true else {
                return
            }
            
            if (isHighlighted == true) {
                contentView.backgroundColor = Theme.current.secondary
            } else {
                contentView.backgroundColor = Theme.current.primary
            }
        }
    }
    
    public var roundedCorners: UIRectCorner = [] {
        didSet {
            makeCorners()
        }
    }
    
    
    public override var cornerRadius: CGFloat {
        didSet {
            makeCorners()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = Theme.current.primary
        makeCorners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.backgroundColor = Theme.current.primary
        makeCorners()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCorners()
    }
    
    private func makeCorners() {
        
        let cornerMaskPath = UIBezierPath(roundedRect: bounds,
                                          byRoundingCorners: roundedCorners,
                                          cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let cornerMaskLayer = CAShapeLayer()
        
        cornerMaskLayer.frame = bounds
        cornerMaskLayer.path = cornerMaskPath.cgPath
        
        contentView.layer.mask = nil
        contentView.layer.mask = cornerMaskLayer
        contentView.layer.borderWidth = 0.0
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isHighlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.isHighlighted = false
    }
        
    func apply(theme: Theme) {
        self.contentView.backgroundColor = theme.primary
    }
}
