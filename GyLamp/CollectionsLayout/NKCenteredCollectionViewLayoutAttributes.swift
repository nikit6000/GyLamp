//
//  NKCenteredCollectionViewLayoutAttributes.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 22/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKCenteredCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)

    var scale: CGFloat = 0 {
    // 2
        didSet {
            //zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    // 3
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: NKCenteredCollectionViewLayoutAttributes = super.copy(with: zone) as! NKCenteredCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.scale = self.scale
        return copiedAttributes
    }
    
}
