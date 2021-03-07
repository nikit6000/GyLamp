//
//  NKStringConvertableParamCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.03.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKStringConvertableParamCell: ImageBassedTableCell, ListBindable {
    
    private lazy var paramLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 15, weight: .medium)
        view.textAlignment = .right
        view.textColor = .lightGray
        return view
    }()
    
    public var param: String? {
        get {
            return paramLabel.text
        }
        set {
            paramLabel.isHidden = newValue == nil
            
            guard let newValue = newValue else {
                return
            }
            
            if newValue.isEmpty {
                paramLabel.text = "N/A"
            } else {
                paramLabel.text = newValue
            }
                       
        }
    }
 
    override func initViews() {
        super.initViews()
        contentView.addSubview(paramLabel)
    }
    
    override func applyConstraints() {

        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: paramLabel.trailingAnchor, constant: 8.0),
            paramLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            paramLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.33)
        ])
        
        super.applyConstraints()
    }
    
    func bindViewModel(_ viewModel: Any) { }
    
}
