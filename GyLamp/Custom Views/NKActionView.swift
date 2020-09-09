//
//  NKActionView.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit
import Material

enum NKActionViewButtonStyle : Int {
    case `default`
    case danger
    case cancel
}

class NKActionView: UIView {
    
    private weak var extraView: UIView?
    private var viewRef: UIView?
    private var viewSnapshot: UIImageView?
    private var viewOrigFrame: CGRect?
    private var actionContainerTopConstrain: NSLayoutConstraint!
    private var actionContainerLeadingConstrain: NSLayoutConstraint!
    private var actionContainerHeightConstrain: NSLayoutConstraint!
    
    private var actionsClosures: [(_ sender: UIButton) -> ()] = []
    
    //MARK:  Views defines
    
    private lazy var effectView: UIVisualEffectView = {
        
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.effect = nil
        
        return view
    }()
    
    private lazy var actionContainer: UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.clipsToBounds = true
        
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        view.isHidden = true
        
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(effectView)
        self.addSubview(actionContainer)
        
        self.setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(for view: UIView) {
        
        guard let window = UIApplication.shared.delegate?.window, let superView = view.superview else {
            return
        }
        
        window?.addSubview(self)
        
        self.frame = UIScreen.main.bounds
        
        self.layoutIfNeeded()
        
        self.isHidden = false
        
        let snapshotFrame = superView.convert(view.frame, to: nil)
        
        viewRef = view
        view.isHidden = false
        viewSnapshot = UIImageView()//view.snapshotView(afterScreenUpdates: true)
        viewSnapshot?.frame = snapshotFrame
        viewOrigFrame = view.frame
        
        drawSnapshot()
        
        view.isHidden = true
        
        if viewSnapshot != nil {
            self.addSubview(viewSnapshot!)
        }
        
        if actionContainer.subviews.count > 0 {
            actionContainer.alpha = 0
            actionContainer.isHidden = false
        }
        
        var newActionViewLocation: CGPoint = .zero
        var snapOffset: CGFloat = 0
        
        var safeBottomOffset: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            //let topPadding = window?.safeAreaInsets.top ?? 0.0
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
            
            safeBottomOffset = bottomPadding
            
        }
        
        NKLog(snapshotFrame.minX , actionContainer.frame.width)
        if (snapshotFrame.minX + actionContainer.frame.width < self.frame.width - 4.0) {
            newActionViewLocation.x = snapshotFrame.minX
        } else {
            newActionViewLocation.x = self.frame.width - actionContainer.frame.width - 4.0
        }
        
        if (snapshotFrame.maxY + actionContainer.frame.height < (self.frame.height - safeBottomOffset - 16.0)) {
            newActionViewLocation.y = snapshotFrame.maxY + 8.0
        } else {
            newActionViewLocation.y = self.frame.height - actionContainer.frame.height - safeBottomOffset - 8.0
            snapOffset = snapshotFrame.maxY - newActionViewLocation.y + 8.0
        }
        
        if extraView != nil {
            extraView!.alpha = 1.0
            
            let width = self.frame.width - 32.0
            let y = snapshotFrame.origin.y - snapOffset - self.frame.size.width
            
            extraView!.frame = CGRect(x: 16.0, y: y, width: width, height: width)
            extraView!.setNeedsLayout()
            extraView!.layoutIfNeeded()
            self.addSubview(extraView!)
        }
        
        
        actionContainerTopConstrain.constant = newActionViewLocation.y
        actionContainerLeadingConstrain.constant = newActionViewLocation.x
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut ,animations: { [weak self] in
            self?.viewSnapshot?.transform = CGAffineTransform(translationX: 0, y: -snapOffset)
            self?.effectView.effect = UIBlurEffect(style: .dark)
            self?.actionContainer.alpha = 1.0
            
            if self?.extraView != nil {
                self?.extraView!.alpha = 1.0
            }
            
            self?.actionContainer.layoutIfNeeded()
        })
    }
    
    @objc func dismiss(hideSnapshot: Bool = false) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut ,animations: { [weak self] in
            self?.viewSnapshot?.transform = .identity
            
            if hideSnapshot {
                self?.viewSnapshot?.alpha = 0.0
            }
            
            self?.effectView.effect = nil
            self?.actionContainer.alpha = 0
            
            if self?.extraView != nil {
                self?.extraView?.alpha = 0
            }
            
        }, completion: { [weak self] _ in
            self?.viewRef?.isHidden = false
            self?.viewSnapshot?.removeFromSuperview()
            self?.extraView?.removeFromSuperview()
            self?.isHidden = true
            self?.removeFromSuperview()
        })
        
    }
    
    private func setupConstaints() {
        
        //MARK: effectView constraint
        
        NSLayoutConstraint(item: effectView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: effectView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: effectView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        //MARK: actionContainer
        
        NSLayoutConstraint(item: actionContainer, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.66, constant: 0).isActive = true
        
        actionContainerLeadingConstrain = NSLayoutConstraint(item: actionContainer,
                                                         attribute: .leading,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .leading,
                                                         multiplier: 1,
                                                         constant: 0)
        
        actionContainerTopConstrain = NSLayoutConstraint(item: actionContainer,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .top,
                                                         multiplier: 1,
                                                         constant: 0)
        
        actionContainerHeightConstrain = NSLayoutConstraint(item: actionContainer,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1,
                                                         constant: 40)
        
        actionContainerLeadingConstrain.isActive = true
        actionContainerTopConstrain.isActive = true
        actionContainerHeightConstrain.isActive = true
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss()
    }
    
    @objc private func onButtonAction(_ sender: UIButton) {
        
        if sender.tag > 0 {
            actionsClosures[sender.tag - 1](sender)
            drawSnapshot()
        }
        
    }
    
    private func createButtonWith(title: String, for style: NKActionViewButtonStyle) -> FlatButton {
        
        let button = FlatButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        
        switch style {
        case .default:
            button.setTitleColor(.white, for: .normal)
        default:
            button.setTitleColor(.lightGray, for: .normal)
        }
        
        return button
    }
    
    deinit {
        NKLog("NKActionView - deinit")
    }
    
    //MARK: - Public functions
    
    public func addAction(_ title: String, style: NKActionViewButtonStyle, action closure: ((_ sender: UIButton)->())? = nil) {
        
        let button = createButtonWith(title: title, for: style)
        
        if closure != nil {
            actionsClosures.append(closure!)
            button.addTarget(self, action: #selector(NKActionView.onButtonAction(_:)), for: .touchUpInside)
            button.tag = actionsClosures.count
        } else {
            button.addTarget(self, action: #selector(NKActionView.dismiss), for: .touchUpInside)
        }
        
        let lastView = actionContainer.subviews.last
        
        actionContainer.addSubview(button)
        
        actionContainerHeightConstrain.constant = 40.0 * CGFloat(actionContainer.subviews.count)
        
        NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: actionContainer, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: actionContainer, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        if lastView != nil {
            NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: lastView!, attribute: .top, multiplier: 1, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: actionContainer, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        }
        
        
    }
    
    public func addExtra(view: UIView) {
        extraView = view
    }
    
    public func drawSnapshot() {
        
        guard let snapshot = viewSnapshot, let refView = self.viewRef else {
            return
        }
        
        refView.isHidden = false
        
        let renderer = UIGraphicsImageRenderer(size: refView.bounds.size)
        
        let image = renderer.image { ctx in
            refView.drawHierarchy(in: refView.bounds, afterScreenUpdates: true)
        }
        
        refView.isHidden = true
        
        snapshot.image = image
        
    }
    
}
