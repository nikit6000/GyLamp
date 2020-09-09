//
//  NKSlidersCollectionCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import IGListKit
import Material
import Motion
import RxSwift

final class NKSlidersCollectionCell: UICollectionViewCell {
    
    private var longPressRecognizer: UILongPressGestureRecognizer?
    private var tapGestureRecognizer: UILongPressGestureRecognizer?
    
    private var lastTapCell: UICollectionViewCell?
    
    lazy var collectionView: NKCollectionView = {
        let layout = NKCenteredCollectionViewLayout()
        let view = NKCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.bounces = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delaysContentTouches = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(collectionView)
        
        //let gesture: UILongPressGestureRecognizer
        
        //if #available(iOS 10.0, *) {
        //    gesture = NKForceGesture(target: self, action: #selector(NKCollectionCell.onGesture(_:)))
        //}
        
        addGestures()
        
        //contentView.isUserInteractionEnabled = true
        
        //self.isUserInteractionEnabled = true
        
        //self.superview?.isUserInteractionEnabled = true
        self.applyConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func longPressed(_ sender: UILongPressGestureRecognizer)
    {
        let location = sender.location(in: collectionView)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        guard let indexPath = collectionView.indexPathForItem(at: location), let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        if sender.state == .began {
            if let alarmCell = cell as? NKAlarmCell {
                appDelegate.showTimeSelector(for: alarmCell)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            
        }
    }
    
    @objc private func tap(_ sender: UILongPressGestureRecognizer)
    {

        let location = sender.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else {
            return
        }
        
        if sender.state == .began {
            
            
        } else if sender.state == .cancelled || sender.state == .ended {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    
    private func addGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NKSlidersCollectionCell.tap(_:)))
        self.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: setting up AutoLayout
    
    private func applyConstraints(){
        
        // collectionView
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: collectionView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
        setNeedsLayout()
        layoutIfNeeded()
        
    }
}
