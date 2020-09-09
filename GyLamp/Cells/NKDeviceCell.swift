//
//  NKDeviceCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay


class NKDeviceCell: UICollectionViewCell, NKViewPressAble {
    
    var isPressAble: Bool
    var isLongPressAble: Bool
    
    
    private var disposeBag: DisposeBag?
    
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .gray
        view.isHidden = true
        return view
    }()
    
    public var model: NKDeviceModel? {
        didSet {
            update()
            
            guard let model = model else {
                return
            }
            
            disposeBag = nil
            disposeBag = DisposeBag()
            
            model.modelUpdatedSubject
                .asDriver(onErrorJustReturn: ())
                .drive(onNext: { [weak self] in
                    self?.update()
                }, onDisposed: {
                    NKLog("[NKDeviceCell] - disposed")
                })
                .disposed(by: disposeBag!)
        }
    }
    
    override init(frame: CGRect) {
        
        isPressAble = true
        isLongPressAble = true
        
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(accessLabel)
        contentView.addSubview(activityIndicator)
        
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
        NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: iconView, attribute: .bottom, multiplier: 1, constant: 4).isActive = true
        
        /* accessLabel */
        NSLayoutConstraint(item: accessLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: accessLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: accessLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: accessLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10).isActive = true
        
        
        /* adressLabel */
        NSLayoutConstraint(item: adressLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: accessLabel, attribute: .top, relatedBy: .equal, toItem: adressLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: adressLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: adressLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12).isActive = true
        
        /* nameLabel */
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: adressLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12).isActive = true
        
        /* activityIndicator */
        NSLayoutConstraint(item: activityIndicator, attribute: .width, relatedBy: .equal, toItem: activityIndicator, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: activityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0).isActive = true
        NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 8.0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: activityIndicator, attribute: .trailing, multiplier: 1.0, constant: 8.0).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    private func update() {
        guard let model = self.model else {
            return
        }
        
        nameLabel.text = model.name ?? "GyLamp"
        adressLabel.text = model.ip
        accessLabel.text = model.isReachable ? NSLocalizedString("device.reachable", comment: "") :
                                               NSLocalizedString("device.unreachable", comment: "")
        
        accessLabel.textColor = model.isReachable ? #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1) :
                                                    UIColor.lightGray
        
        iconView.image = model.icon
    
        if model.isOn {
            self.contentView.alpha = 1.0
        } else {
            self.contentView.alpha = 0.7
        }
        
        if model.isBusy {
            activityIndicator.startAnimating()
            activityIndicator.showAnimated()
        } else {
            activityIndicator.hideAnimated {  [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    
}
