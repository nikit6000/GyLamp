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
        view.contentView.addSubview(collectionView)
        return view
        
    }()
    
    private lazy var imageView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.addSubview(effectView)
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()

        view.addSubview(imageView)
        
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupConstraints() {
        
        
        NSLayoutConstraint.activate([

            
            effectView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            effectView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            effectView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            effectView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            
            collectionView.centerYAnchor.constraint(equalTo: effectView.contentView.centerYAnchor),
            collectionView.centerXAnchor.constraint(equalTo: effectView.contentView.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: effectView.contentView.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: effectView.contentView.heightAnchor),

            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        
    }
    
}

extension NKBlurViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
    }
}
