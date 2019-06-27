//
//  NKEffectCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class NKEffectCell: UICollectionViewCell {
    
    private var disposeBag:DisposeBag?
    
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
    
    private lazy var brightnessLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 10)
        view.textColor = UIColor.lightGray
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    public var model: NKEffect? {
        didSet {
            update()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(iconView)
        contentView.addSubview(indicator)
        contentView.addSubview(nameLabel)
        contentView.addSubview(brightnessLabel)
        
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
        
        /* indicator */
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: indicator, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: indicator, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        
        /* brightnessLabel */
        NSLayoutConstraint(item: brightnessLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: brightnessLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: brightnessLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* nameLabel */
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: brightnessLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    private func update() {
        guard let model = self.model else {
            return
        }
        
        nameLabel.text = model.mode.name
        
        
        
        disposeBag = nil
        disposeBag = DisposeBag()
        
        model.isLoadingRelay.asDriver()
                            .drive(onNext: { [weak self] value in
                                if value {
                                    self?.indicator.startAnimating()
                                    self?.indicator.showAnimated()
                                } else {
                                    self?.indicator.hideAnimated(completion: {
                                        self?.indicator.stopAnimating()
                                    })
                                }
                            })
                            .disposed(by: disposeBag!)
        
        model.isSetRelay.asDriver()
                            .drive(onNext: { [weak self] value in
                                self?.iconView.image = value ? #imageLiteral(resourceName: "light.on") : #imageLiteral(resourceName: "light.off")
                                self?.contentView.alpha = value ? 1.0 : 0.7
                            })
                            .disposed(by: disposeBag!)
        
        model.brightnessRelay.asDriver()
                            .drive(onNext: { [weak self] value in
                                self?.brightnessLabel.text = "\(Int(value * 100.0))%"
                            })
                            .disposed(by: disposeBag!)
        
    }
    
}
