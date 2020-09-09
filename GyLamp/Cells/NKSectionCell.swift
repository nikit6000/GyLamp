//
//  NKHeaderCell.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NKSectionCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 25)
        view.textColor = .white
        
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    public var model: NKSectionModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            self.titleLabel.text = model.title

            if model.isLoading {
                indicator.startAnimating()
                indicator.isHidden = false
            } else {
                indicator.isHidden = true
                indicator.stopAnimating()
            }
            
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
            
        }
    }
    
    override init(frame: CGRect) {

        super.init(frame: .zero)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(indicator)
        
        self.contentView.backgroundColor = .clear
        
        
        setupConstarints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not supported")
    }
    
    
    
    private func setupConstarints() {
        
        /* indicator */
        
        NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: indicator, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: indicator, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        /* titleLabel */
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8.0).isActive = true
        /*NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 8.0).isActive = true*/
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    /*override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = contentView.frame.size.width//ceil(size.width)
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }*/
    
}
