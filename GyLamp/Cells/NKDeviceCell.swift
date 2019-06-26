//
//  NKDeviceCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKDeviceCell: UICollectionViewCell {
    
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var adressLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var accessLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 10)
        view.textColor = UIColor.lightGray
        return view
    }()
    
    public var model: NKDeviceModel? {
        didSet {
            guard let model = self.model else {
                return
            }
            
            nameLabel.text = model.name ?? "GyLamp"
            adressLabel.text = model.ip
            accessLabel.text = model.isReachable ?  NSLocalizedString("device.reachable", comment: "") :
                                                    NSLocalizedString("device.unreachable", comment: "")
            
            iconView.image = model.icon
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(accessLabel)
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        
        contentView.backgroundColor = .white
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        /* iconView */
        NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* accessLabel */
        NSLayoutConstraint(item: accessLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: accessLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: accessLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* adressLabel */
        NSLayoutConstraint(item: adressLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: accessLabel, attribute: .top, relatedBy: .equal, toItem: adressLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: adressLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* nameLabel */
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: adressLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
}
