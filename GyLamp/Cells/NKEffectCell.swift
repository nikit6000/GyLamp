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
import Squircle

class NKEffectCell: UICollectionViewCell, NKPressableCellProtocol {
    
    var isPressAble: Bool = true
    var isLongPressAble: Bool = false
    
    private var disposeBag:DisposeBag?
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "fx")?.tint(with: .lightGray)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14, weight: .semibold)
        view.numberOfLines = 3
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
    
    private lazy var errorImage: UIImageView = {
        let view = UIImageView()
           
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.image = #imageLiteral(resourceName: "warning.30px")
        return view
    }()
    
    public var model: NKEffect? {
        didSet {
            update()
            
            guard let model = self.model else {
                return
            }
            
            disposeBag = nil
            disposeBag = DisposeBag()
            
            model.deviceModel?.modelUpdatedSubject
                .asDriver(onErrorJustReturn: ())
                .drive(onNext: { [weak self] in
                    self?.update()
                }, onDisposed: {
                    NKLog("[NKEffectCell] - disposed")
                })
                .disposed(by: disposeBag!)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
        contentView.addSubview(indicator)
        contentView.addSubview(nameLabel)
        contentView.addSubview(brightnessLabel)
        contentView.addSubview(errorImage)
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        
        contentView.backgroundColor = .white
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.squircle()
    }
    
    private func setupConstraints() {
        
        /* iconView */
        NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* indicator */
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: indicator, attribute: .trailing, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: indicator, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* errorImage */
        NSLayoutConstraint(item: errorImage, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: errorImage, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: errorImage, attribute: .width, relatedBy: .equal, toItem: errorImage, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: errorImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        
        /* brightnessLabel */
        NSLayoutConstraint(item: brightnessLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: brightnessLabel, attribute: .bottom, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: brightnessLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* nameLabel */
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: brightnessLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 12).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    private func update() {
        guard let model = self.model else {
            return
        }
        
        nameLabel.text = model.mode
        
        self.contentView.alpha = (model.isSet == true) ? 1.0 : 0.7
        
        if (model.isLoading) {
            indicator.startAnimating()
            indicator.isHidden = false
        } else {
            indicator.isHidden = true
            indicator.stopAnimating()
        }
        
        if (model.hasError) {
            model.hasError = false
            showError()
        }
    
        
    }
    
    private func showError() {
        
        errorImage.showAnimated()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.errorImage.hideAnimated {}
        })
        
    }
    
}
