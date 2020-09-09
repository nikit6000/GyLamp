//
//  NKNativeAdCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 12.05.2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NKNativeAdCell: UICollectionViewCell {
    
    private lazy var template: GADTSmallTemplateView = {
       
        let view = GADTSmallTemplateView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
        
    }()
    
    public var nativeAd: GADUnifiedNativeAd? {
        set {
            template.nativeAd = newValue
        }
        get {
            return template.nativeAd
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(template)
        self.setupConstraints()
        
        
        let styles: [GADTNativeTemplateStyleKey: NSObject] = [
            .callToActionBackgroundColor: #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1),
            .callToActionFont: UIFont.systemFont(ofSize: 15.0),
            .callToActionFontColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            .secondaryFont: UIFont.systemFont(ofSize: 15.0),
            .secondaryFontColor: UIColor.gray,
            .secondaryBackgroundColor: UIColor.white,
            .primaryFont: UIFont.systemFont(ofSize: 15.0),
            .primaryFontColor: UIColor.black,
            .primaryBackgroundColor: UIColor.white,
            .tertiaryFont: UIFont.systemFont(ofSize: 15.0),
            .tertiaryFontColor: UIColor.gray,
            .tertiaryBackgroundColor: UIColor.white,
            .mainBackgroundColor: UIColor.white,
            .cornerRadius: NSNumber(value: 15.0)
        ]
        
        template.callToActionView?.isUserInteractionEnabled = false
        //template.mediaView?.contentMode = .scaleAspectFill
        
        template.styles = styles
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        template.addHorizontalConstraintsToSuperviewWidth()
        template.addVerticalCenterConstraintToSuperview()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15.0
    }
    
}
