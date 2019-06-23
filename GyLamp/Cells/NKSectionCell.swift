//
//  NKHeaderCell.swift
//  GyLamp
//
//  Created by Никита on 18/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift

class NKSectionCell: UICollectionViewCell {
    
    private var disposeBag: DisposeBag
    
    private var labelTopConstraint: NSLayoutConstraint!
    private var labelBottomConstraint: NSLayoutConstraint!
    private var hairlineTopConstraint: NSLayoutConstraint!
    private var hairlineBottomConstraint: NSLayoutConstraint!
    
    private lazy var hairline: NKHairlineView = {
        let view = NKHairlineView(style: .bottom)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .lightGray
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 4
        
        return view
    }()
    
    public var model: NKSectionModel? {
        didSet {
            
            guard let strongModel = model else {
                return
            }
            
            self.titleLabel.text = strongModel.title
            
            switch strongModel.style {
            case .bottom:
                hairlineBottomConstraint.isActive = false
                hairlineTopConstraint.isActive = true
                
                labelBottomConstraint.constant = 16.0
                labelTopConstraint.constant = 4.0
                
                hairline.style = .top
                
                break
            case .top:
                hairlineBottomConstraint.isActive = true
                hairlineTopConstraint.isActive = false
                
                labelBottomConstraint.constant = 4.0
                labelTopConstraint.constant = 16.0
                
                hairline.style = .bottom
                
                break
            }
            
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
            
        }
    }
    
    override init(frame: CGRect) {
        
        disposeBag = DisposeBag()
        
        super.init(frame: .zero)
        
        self.contentView.addSubview(hairline)
        self.contentView.addSubview(titleLabel)
        
        self.contentView.backgroundColor = ColorUtil.shared.colorizer.value.palette[.sections]
        self.titleLabel.textColor = ColorUtil.shared.colorizer.value.palette[.sectionText] ?? UIColor.lightGray
        
        ColorUtil.shared.colorizer.subscribe(onNext: { value in
            self.contentView.backgroundColor = value.palette[.sections]
            self.titleLabel.textColor = value.palette[.sectionText] ?? UIColor.lightGray
        }).disposed(by: disposeBag)
        
        setupConstarints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not supported")
    }
    
    private func setupConstarints() {
        /* hairline */
        NSLayoutConstraint(item: hairline, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: hairline, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: hairline, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0).isActive = true
        
        hairlineTopConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: hairline, attribute: .top, multiplier: 1.0, constant: 0.0)
        hairlineBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: hairline, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        hairlineBottomConstraint.isActive = true
        
        /* titleLabel */
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 8.0).isActive = true
        labelTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 16.0)
        labelBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 4.0)
        
        labelTopConstraint.isActive = true
        labelBottomConstraint.isActive = true
       
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = contentView.frame.size.width//ceil(size.width)
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
}
