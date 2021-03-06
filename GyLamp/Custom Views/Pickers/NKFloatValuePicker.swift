//
//  NKFloatValuePicker.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 07.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import Lottie

extension UIAlertController {
    
    func addSliderView(initialValue: Float, action: NKFloatValuePicker.Action? = nil) {
        let vc = NKFloatValuePicker(initialValue: initialValue, action: action)
        set(vc: vc, width: 100, height: 250)
    }
    
}

enum NKFloatValuePickerAction {
    case touchUp
    case touchDown
    case valueChanged(_ value: Float)
}

final class NKFloatValuePicker: UIViewController {
    
    public typealias Action = (_ vc: UIViewController, _ picker: NKVerticalSlider, _ action: NKFloatValuePickerAction) -> ()
    
    fileprivate var pickedValue: Float = 0.0
    fileprivate var action: Action?
    
    fileprivate lazy var slider: NKLottieVerticalSlider = {
        let view = NKLottieVerticalSlider()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(sliderHandler), for: .valueChanged)
        view.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        view.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
        
        view.animation = Animation.named("brightness")
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        
        //view.layer.shouldRasterize = true
        //view.layer.rasterizationScale = UIScreen.main.scale
        
        return view
    }()
    
    init(initialValue: Float = 0.0, action: Action? = nil) {
        self.pickedValue = initialValue
        self.action = action
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slider)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        slider.value = CGFloat(self.pickedValue)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalToConstant: 90.0),
            slider.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -36.0),
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func sliderHandler() {
        self.pickedValue = Float(slider.value)
        action?(self, slider, .valueChanged(self.pickedValue))
    }
    
    @objc private func sliderTouchDown() {
        action?(self, slider, .touchDown)
    }
    
    @objc private func sliderTouchUp() {
        action?(self, slider, .touchUp)
    }
}
