//
//  NKBoolParamCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 14.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKBoolParamCell: ImageBassedTableCell, ListBindable {
    
    private lazy var paramSwitch: UISwitch = {
        let view = UISwitch(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(switchHandler), for: .valueChanged)
        return view
    }()
    
    public var param: Bool {
        get {
            return paramSwitch.isOn
        }
        set {
            paramSwitch.isOn = newValue
        }
    }
    
    public var handler: ((_ state: Bool) -> ())?
 
    override func initViews() {
        super.initViews()
        contentView.addSubview(paramSwitch)
    }
    
    override func applyConstraints() {
        
        /* paramSwitch */
        
        NSLayoutConstraint.activate([
            paramSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            paramSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        super.applyConstraints()
    }
    
    func bindViewModel(_ viewModel: Any) {
        guard let model = viewModel as? NKBoolListMoldel else { return }
        
        self.image = model.icon
        self.title = model.title
        self.subtitle = nil
        self.isImageRounded = false
        self.param = model.value
        
    }
    
    @objc private func switchHandler() {
        handler?(paramSwitch.isOn)
    }
    
}
