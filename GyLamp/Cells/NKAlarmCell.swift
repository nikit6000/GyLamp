//
//  NKAlarmCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class NKAlarmCell: UICollectionViewCell, NKViewPressAble {
    
    var isPressAble: Bool = true
    var isLongPressAble: Bool = true
    
    
    private var disposeBag: DisposeBag?
    
    
    private lazy var dawnLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor.lightGray
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.textAlignment = .center
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor.lightGray
        view.textAlignment = .left
        return view
    }()
    
    private lazy var hoursLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 30)
        view.textColor = UIColor.black
        view.textAlignment = .right
        return view
    }()
    
    private lazy var minutesLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15)
        
        view.textColor = UIColor.black
        view.textAlignment = .left
        return view
    }()
    
    private lazy var amLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "am"
        view.textColor = UIColor.black
        view.textAlignment = .left
        return view
    }()
    
    private lazy var pmLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "pm"
        view.textColor = UIColor.black
        view.textAlignment = .left
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "alarm")
        view.isHidden = true
        return view
    }()
    
    private lazy var sunsetIconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "alarm")
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
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    public var model: NKAlarmModel? {
        didSet {
            update()
            
            guard let model = self.model?.deviceModel else {
                return
            }
            
            disposeBag = nil
            disposeBag = DisposeBag()
    
            model.modelUpdatedSubject
                .asDriver(onErrorJustReturn: ())
                .drive(onNext: { [weak self] in
                    self?.update()
                }, onDisposed: {
                    NKLog("[NKAlarmCell] model driver disposed")
                })
                .disposed(by: disposeBag!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(hoursLabel)
        contentView.addSubview(minutesLabel)
        contentView.addSubview(amLabel)
        contentView.addSubview(pmLabel)
        contentView.addSubview(dayLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(sunsetIconView)
        contentView.addSubview(dawnLabel)
        contentView.addSubview(indicator)
        contentView.addSubview(errorImage)
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        
        contentView.backgroundColor = .white
        
        if UIScreen.main.scale == 3.0 {
            /* iPhone 7 Plus and above*/
            hoursLabel.font = .systemFont(ofSize: 30)
            minutesLabel.font = .systemFont(ofSize: 15)
            amLabel.font = .systemFont(ofSize: 15)
            pmLabel.font = .systemFont(ofSize: 15)
        } else  {
            hoursLabel.font = .systemFont(ofSize: 20)
            minutesLabel.font = .systemFont(ofSize: 10)
            amLabel.font = .systemFont(ofSize: 10)
            pmLabel.font = .systemFont(ofSize: 10)
        }
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dawnLabel.sizeToFit()
        dawnLabel.layer.cornerRadius = dawnLabel.frame.height / 2.0
    }
    
    
    private func setupConstraints() {
        
        let amPmLabelFontSize: CGFloat = UIScreen.main.scale == 3.0 ? 15.0 : 10.0
        
        /* iconView */
        NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* sunsetIconView */
        NSLayoutConstraint(item: sunsetIconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: sunsetIconView, attribute: .width, relatedBy: .equal, toItem: sunsetIconView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sunsetIconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: sunsetIconView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* indicator */
        NSLayoutConstraint(item: indicator, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: indicator, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* errorImage */
        NSLayoutConstraint(item: errorImage, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: errorImage, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: errorImage, attribute: .width, relatedBy: .equal, toItem: errorImage, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: errorImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* dawnLabel */
        
        NSLayoutConstraint(item: dawnLabel, attribute: .centerX, relatedBy: .equal, toItem: sunsetIconView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dawnLabel, attribute: .centerY, relatedBy: .equal, toItem: sunsetIconView, attribute: .centerY, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: dawnLabel, attribute: .width, relatedBy: .equal, toItem: sunsetIconView, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
        
        /* hoursLabel */
        
        NSLayoutConstraint(item: hoursLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: hoursLabel, attribute: .bottom, relatedBy: .equal, toItem: dayLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        /* minutesLabel */
        
        NSLayoutConstraint(item: minutesLabel, attribute: .leading, relatedBy: .equal, toItem: hoursLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: minutesLabel, attribute: .top, relatedBy: .equal, toItem: hoursLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        /* amLabel */
        NSLayoutConstraint(item: amLabel, attribute: .centerY, relatedBy: .equal, toItem: hoursLabel, attribute: .centerY, multiplier: 1, constant: (-amPmLabelFontSize / 2.0) - 1.5 ).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: amLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* pmLabel */
        NSLayoutConstraint(item: pmLabel, attribute: .centerY, relatedBy: .equal, toItem: hoursLabel, attribute: .centerY, multiplier: 1, constant: (amPmLabelFontSize / 2.0) + 1.5).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: pmLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* dayLabel */
        NSLayoutConstraint(item: dayLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: dayLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: dayLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    private func update() {
        guard let model = self.model else {
            return
        }
        
        //let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single]
        
        let amPm = model.amPm
        
        if amPm == nil {
            amLabel.isHidden = true
            pmLabel.isHidden = true
        } else {
            amLabel.isHidden = false
            pmLabel.isHidden = false
            
            if (amPm!.lowercased() == "am") {
                amLabel.textColor = .black
                pmLabel.textColor = .lightGray
            } else {
                pmLabel.textColor = .black
                amLabel.textColor = .lightGray
            }
        }
        
        self.hoursLabel.text = model.hoursText
        //self.minutesLabel.attributedText = NSAttributedString(string: model.minutesText, attributes: underlineAttribute)
        self.minutesLabel.text = model.minutesText
        self.dayLabel.text = model.day.getDayShort()
        
        if model.isOn {
            self.contentView.alpha = 1.0
            self.sunsetIconView.image = #imageLiteral(resourceName: "dawn.on")
        } else {
            self.contentView.alpha = 0.7
            self.sunsetIconView.image = #imageLiteral(resourceName: "dawn.off")
        }
        
        if (model.hasError) {
            model.hasError = false
            showError()
        }
        
        if (model.isLoading) {
            indicator.startAnimating()
            indicator.isHidden = false
        } else {
            indicator.isHidden = true
            indicator.stopAnimating()
        }
        
        dawnLabel.text = model.dawnOffsetStr
        
    }
    
    private func showError() {
        
        errorImage.showAnimated()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.errorImage.hideAnimated {}
        })
        
    }
    
}

