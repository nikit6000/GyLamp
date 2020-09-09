//
//  NKProgressCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class NKProgressCell: UICollectionViewCell, NKViewPressAble {
    
    public var isPressAble: Bool = false
    
    public var isLongPressAble: Bool = false
    
    
    private lazy var progressView: MBCircularProgressBarView = {
       
        let view = MBCircularProgressBarView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.progressAngle = 80
        view.progressColor = .gray
        view.progressCapType = 1
        view.progressStrokeColor = .clear
        view.progressLineWidth = 10
        
        view.showValueString = true
        view.showUnitString = false
        
        view.emptyCapType = 1
        view.emptyLineColor = UIColor.lightGray.withAlphaComponent(0.6)
        view.emptyLineWidth = 8
        
        view.backgroundColor = .clear
        
        return view
        
    }()
    
    public var progress: CGFloat {
        get {
            return progressView.value
        }
        set {
            progressView.value = newValue
        }
    }
    
    public var maxValue: CGFloat {
        get {
            return progressView.maxValue
        }
        set {
            progressView.maxValue = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(progressView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        /* progressView */
        
        NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 4.0).isActive = true
        NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 4.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: progressView, attribute: .trailing, multiplier: 1, constant: 4.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: progressView, attribute: .bottom, multiplier: 1, constant: 4.0).isActive = true
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
    }
    
}
