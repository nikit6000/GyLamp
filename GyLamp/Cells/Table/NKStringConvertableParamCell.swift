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
            paramLabel.text = newValue
            paramLabel.isHidden = newValue == nil
        }
    }
 
    override func initViews() {
        super.initViews()
        contentView.addSubview(paramLabel)
    }
    
    override func applyConstraints() {
        /* titleLabel */
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: paramLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: paramLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        super.applyConstraints()
    }
    
    func bindViewModel(_ viewModel: Any) { }
    
}
