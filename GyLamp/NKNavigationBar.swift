//
//  NKNavigationBar.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import Material

enum NKNavigationBarState: Int {
    case normal = 0
    case reverced = 1
}

class NKNavigationBar: UINavigationBar {
    
    private var titleGradientlayer = CAGradientLayer()
    
    private var customHeight : CGFloat = 44
    
    public var isBarVisible: Bool {
        didSet {
            self.shadowImage = isBarVisible ? nil : UIImage()
            self.setBackgroundImage(self.shadowImage, for: .default)
        }
    }
    
    lazy private var effectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.titleGradientlayer.locations = [0, 1]
        self.titleGradientlayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        view.layer.addSublayer(self.titleGradientlayer)
        return view
    }()
    
    private lazy var barGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.locations = [0, 1]
        layer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        return layer
    }()
    
    override init(frame: CGRect) {
        isBarVisible = true
        super.init(frame: frame)
        self.isTranslucent = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        barGradient.frame = CGRect(x: 0, y: -statusBarHeight, width: self.frame.width, height: self.frame.height + statusBarHeight)
        self.layer.insertSublayer(barGradient, at: 1)
    }
    
}

