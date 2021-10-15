//
//  NKTimeEdit.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKTimeEdit: UIView {
    
    private var action: ((_ date: Date)->())?
    
    private lazy var timePicker: UIDatePicker = {
        let view = UIDatePicker(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datePickerMode = .time
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(NKTimeEdit.dateChanged), for: .valueChanged)
        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = .dark
        } else {
            view.setValue(UIColor.white, forKey: "textColor")
        }
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(timePicker)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if let date = dateFormatter.date(from: "00:00") {
            timePicker.date = date
        }
        
        //self.backgroundColor = .white
        
        setupConstraints()
    }
    
    public var date: Date {
        get {
            return timePicker.date
        }
        set {
            timePicker.date = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        /* timePicker */
        
        NSLayoutConstraint(item: timePicker, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: timePicker, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: timePicker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: timePicker, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc private func dateChanged() {
        action?(timePicker.date)
    }
    
    public func onChange(action: @escaping ((_ date: Date)->())) {
        self.action = action
    }
    
    deinit {
        NKLog("NKTimeEdit - deinit")
    }
    
}
