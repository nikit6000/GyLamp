//
//  NKImageBasedTableCell.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import UIKit
import Material

class ImageBassedTableCell: NKAbsCollectionCell {
    
    
    //MARK: - Internal
    
    internal var extraViewWidthConstraint: NSLayoutConstraint!
    
    //MARK: - Internal UI
    
    internal lazy var extraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    //MARK: - Private
    
    private var titleLabelCenter: NSLayoutConstraint!
    
    //MARK: - Private UI
    
    private lazy var hairlineView: NKHairlineView = {
        let view = NKHairlineView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8

        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .left
        view.textColor = Theme.current.onPrimary
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .left
        view.textColor = Theme.current.onSecondary
        return view
    }()
    
    private let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = Theme.current.surface.cgColor
        return layer
    }()
    
    //MARK: - Public
    
    public var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    public var subtitle: String? {
        get {
            return subtitleLabel.text
        }
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = newValue == nil
            titleLabelCenter.constant = newValue == nil ? 0 : -10
            self.contentView.layoutIfNeeded()
        }
    }
    
    public var isHairlineHidden: Bool {
        get{
            return hairlineView.isHidden
        }
        set {
            hairlineView.isHidden = newValue
        }
    }
    
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    public var isImageRounded: Bool {
        get {
            return imageView.layer.masksToBounds
        }
        set {
            imageView.layer.cornerRadius = newValue ? 15 : 8
            //imageView.layer.borderColor = newValue ? UIColor.lightGray.cgColor : UIColor.clear.cgColor
            //imageView.layer.borderWidth = newValue ? 0.5 : 0.0*/
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.addSublayer(separator)
        initViews()
        applyConstraints()
        
    }
    
    func initViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(hairlineView)
        contentView.addSubview(extraView)
    }
    
    override var isHighlighted: Bool {
        didSet {
            //contentView.backgroundColor = UIColor(white: isHighlighted ? 0.9 : 1, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //NKLog(#file, "deinited")
    }
    
    internal func applyConstraints(){
        
        /* imageView */
        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 12.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        /* titleLabel */
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 12).isActive = true
        titleLabelCenter = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: -10)
        titleLabelCenter.isActive = true
        NSLayoutConstraint(item: extraView, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        /* subtitleLabel */
        NSLayoutConstraint(item: subtitleLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: subtitleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: subtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        
        /* hairlineView */
        NSLayoutConstraint(item: hairlineView, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: hairlineView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: hairlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: hairlineView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        /* extraView */
        NSLayoutConstraint(item: extraView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: extraView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: extraView, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        extraViewWidthConstraint = NSLayoutConstraint(item: extraView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        extraViewWidthConstraint.isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        layoutAttributes.frame.size = size
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = 60
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    override func apply(theme: Theme) {
        super.apply(theme: theme)
        titleLabel.textColor = theme.onPrimary
        subtitleLabel.textColor = theme.onSecondary
    }
    
    
}
