//
//  NKSliderCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 27/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import HGCircularSlider
import RxSwift
import RxRelay

class NKSliderCell: UICollectionViewCell {
    
    private var disposeBag: DisposeBag?
    
    private lazy var sliderView: CircularSlider = {
        let view = CircularSlider(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 0.0
        view.maximumValue = 1.0
        view.numberOfRounds = 1
        view.backgroundColor = .clear
        view.diskFillColor = .clear
        view.diskColor = .white
        view.trackColor = UIColor.black.withAlphaComponent(0.1)
        view.lineWidth = 4
        view.thumbRadius = 10
        view.thumbLineWidth = 1
        view.endThumbStrokeColor = view.trackFillColor
        view.endThumbStrokeHighlightedColor = view.trackFillColor
        view.addTarget(self, action: #selector(NKSliderCell.onSlider), for: .valueChanged)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor.lightGray
        view.textAlignment = .center
        return view
    }()
    
    
    public var model: NKFloatModel? {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(sliderView)
        contentView.addSubview(nameLabel)
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        
        contentView.backgroundColor = .white
        
        sliderView.isUserInteractionEnabled = true
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onSlider() {
        model?.value = sliderView.endPointValue
    }
    
    private func setupConstraints() {
        
        
        /* sliderView */
        
        NSLayoutConstraint(item: sliderView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: sliderView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sliderView, attribute: .width, relatedBy: .equal, toItem: sliderView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sliderView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        /* nameLabel */
        NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    private func update() {
        guard let model = self.model else {
            return
        }
        
        nameLabel.text = model.text
        sliderView.endPointValue = model.value
        
        disposeBag = nil
        disposeBag = DisposeBag()
        
        model.valueRelay.asDriver()
                        .drive(onNext: { [weak self] value in
                            guard let strongSelf = self else {
                                return
                            }
                            if strongSelf.sliderView.endPointValue != value {
                                strongSelf.sliderView.endPointValue = value
                            }
                        })
                        .disposed(by: disposeBag!)
        
    }
}

