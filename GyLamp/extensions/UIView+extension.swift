//
//  UIView+extension.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

extension UIView {
    
    func hideAnimated(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.isHidden = true
            self?.alpha = 1.0
            completion()
        })
    }
    
    func showAnimated() {
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.alpha = 1.0
        })
    }
    
}
