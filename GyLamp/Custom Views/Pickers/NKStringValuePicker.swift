//
//  NKStringValuePicker.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.03.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import Material

extension UIAlertController {
    
    /// Add a textField
    ///
    /// - Parameters:
    ///   - height: textField height
    ///   - hInset: right and left margins to AlertController border
    ///   - vInset: bottom margin to button
    ///   - configuration: textField
    
    func addStringPicker(configuration: NKStringValuePicker.Config?, handler: NKStringValuePicker.Action? = nil) {
        let textField = NKStringValuePicker(configuration: configuration, action: handler)
        let height: CGFloat = 80.0
        set(vc: textField, height: height)
    }
}

class NKStringValuePicker: UIViewController, UITextFieldDelegate, Themeable {
    
    typealias Config = (_ textField: Material.ErrorTextField) -> ()
    typealias Action = (_ textField: Material.ErrorTextField, _ value: String) -> ()

    private var action: Action?
    
    var isThemingEnabled: Bool = true
    
    fileprivate lazy var textField: Material.ErrorTextField = {
        let view = Material.ErrorTextField()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldHandler), for: .editingChanged)
        view.textColor = Theme.current.onPrimary
        
        return view
    }()
    
    
    init(configuration: Config?, action: Action?) {
        self.action = action
        
        super.init(nibName: nil, bundle: nil)
        view.addSubview(textField)
        
        setupConstraints()
        
        configuration?(textField)
        
        preferredContentSize.height = 80.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Using perfom(..., afterDelay: 0.0) instead of calling .becomeFirstResponder() directly will fix animation issue
        textField.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16.0),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc private func textFieldHandler() {
        onTextChanged(textField)
    }
    
    func onTextChanged(_ sender: ErrorTextField) {
        guard let text = sender.text else {
            return
        }
        action?(sender, text)
    }
    
    func apply(theme: Theme) {
        textField.textColor = theme.onPrimary
    }
}
