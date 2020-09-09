//
//  NKBlurViewController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 03/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import IGListKit

class NKBlurViewController : UIViewController {
    
    
    public var effect: UIVisualEffect? {
        set {
            effectView.effect = newValue
        }
        get {
            return effectView.effect
        }
    }
    
    public var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    private lazy var effectView: UIVisualEffectView = {
      
        let view = UIVisualEffectView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var imageView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        
        return view
        
    }()
    
    
    
    private(set) lazy var collectionView: NKCollectionView = {
        
        let layout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true)
        
        let collectionView = NKCollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
        
    }()
    
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(effectView)
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        /* imageView */
        
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        /* effectView */
        
        NSLayoutConstraint(item: effectView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: effectView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: effectView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        /* collectionView */
        
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: collectionView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        
    }
    
}
