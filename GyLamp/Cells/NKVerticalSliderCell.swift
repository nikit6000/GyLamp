//
//  NKVerticalSliderCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

protocol NKVerticalSliderCellDelegate: class {
    
    func verticalSliderCell(_ slider: NKVerticalSlider, changed value: CGFloat)
    
}

class NKVerticalSliderCell: UICollectionViewCell {
    
    private var disposeBag: DisposeBag?
    
    private(set) lazy var slider: NKVerticalSlider = {
        
        let view = NKVerticalSlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.textColor = .black
        view.fontSize = 20
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    override var alpha: CGFloat {
        set {
            super.alpha = newValue
            
            self.slider.isEnabled = !(alpha < 1.0)
            
        }
        get {
            return super.alpha
        }
    }
    
    public var model: NKSliderModel? {
        didSet {
            
            guard let model = self.model else {
                return
            }
            
            
            self.label.text = model.cmd
            self.slider.value = model.value
            
            disposeBag = nil
            disposeBag = DisposeBag()
            
            model.model?.modelUpdatedSubject.asDriver(onErrorJustReturn: ())
                .drive(onNext: { [weak self] in

      //usingSpringWithDamping: 0, initialSpringVelocity: 0
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        self?.slider.value = self?.model?.value ?? 0.0
                    })
                    
                }, onDisposed: {
                    NKLog("[NKVerticalCollectionCell] - disposed")
                })
                .disposed(by: disposeBag!)
            
        }
    }
    
    public weak var delegate: NKVerticalSliderCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(slider)
        self.contentView.addSubview(label)
        slider.addTarget(self, action: #selector(NKVerticalSliderCell.valueChanged(sender:)), for: .valueChanged)
        
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        
        /* slider */
        
        NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: slider, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: slider, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: slider, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        /* label */
        
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.7, constant: 0).isActive = true
        
        self.layoutIfNeeded()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.layer.cornerRadius = label.frame.height / 2.0
    }
    
    @objc private func valueChanged(sender: NKVerticalSlider) {
        delegate?.verticalSliderCell(sender, changed: sender.value)
    }


}
