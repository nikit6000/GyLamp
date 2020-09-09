//
//  NKCenteredCollectionViewLayout.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 22/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKCenteredCollectionViewLayout: UICollectionViewLayout {
    
    var attributesList = [NKCenteredCollectionViewLayoutAttributes]()
    var currentPage: Int = 0
    
    override var collectionViewContentSize: CGSize {
        let width:CGFloat = 100.0
        let newContentWidth = CGFloat(collectionView!.numberOfSections) * (width + 8.0) + (collectionView!.frame.size.width - width) - 8.0
        
        return CGSize(width: newContentWidth, height: collectionView!.frame.height)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return NKCenteredCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        let width: CGFloat = 100.0
       
        
        
        
        attributesList = (0..<collectionView.numberOfSections).map { (i) -> NKCenteredCollectionViewLayoutAttributes in
            
            let indexPath = IndexPath(item: 0, section: i)
            let attribute = NKCenteredCollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let size = CGSize(width: 100, height: 280)
            let origin = CGPoint(x: CGFloat(i) * (size.width + 8.0) + (collectionView.frame.size.width - width) / 2.0, y: 0)
            let frame = CGRect(origin: origin, size: size)
            let contentOffset = collectionView.contentOffset
            
            var scaleFactor = (frame.midX - contentOffset.x) / collectionView.frame.midX
            
            if scaleFactor > 1.0 {
                scaleFactor = 2 - scaleFactor
            }
            
            if scaleFactor < 0.8 {
                scaleFactor = 0.8
            }
            
            
            attribute.scale = scaleFactor
            attribute.frame = frame
            attribute.alpha = scaleFactor
            
            return attribute
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.section]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }

        // Page width used for estimating and calculating paging.
        let pageWidth: CGFloat = 108.0

        // Make an estimation of the current page position.
        let approximatePage = collectionView.contentOffset.x / pageWidth

        // Determine the current page based on velocity.
        let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))

        // Create custom flickVelocity.
        let flickVelocity = velocity.x * 0.3

        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

        // Calculate newHorizontalOffset.
        var newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left

        if (newHorizontalOffset > CGFloat(collectionView.numberOfSections) * pageWidth) {
            newHorizontalOffset = CGFloat(collectionView.numberOfSections) * pageWidth
        } else if (newHorizontalOffset < 0.0) {
            newHorizontalOffset = 0.0
        }
        
        //self.currentPage = Int(currentPage + flickedPages)
        
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
        
    }
    
    func isValidOffset(offset: CGFloat) -> Bool {
        return (offset >= CGFloat(self.minContentOffset()) && offset <= CGFloat(self.maxContentOffset()))
    }
    
    func minContentOffset() -> CGFloat {
        return -CGFloat(self.collectionView!.contentInset.left)
    }

    func maxContentOffset() -> CGFloat {
        return CGFloat(self.minContentOffset() + self.collectionView!.contentSize.width - 100)
    }

    func snapStep() -> CGFloat {
        return 100 + 8;
    }
}
