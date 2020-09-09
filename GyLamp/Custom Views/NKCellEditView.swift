//
//  NKTimeEditView.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

class NKCellEditView: UIView {
    
    private var oldFrame: CGRect
    public var fromAlpha: CGFloat = 1.0
    
    public lazy var cellView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    private lazy var separate: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    override var frame: CGRect {
        didSet {
            separate.frame = self.bounds
            let size = frame.width * 2.5 / 3.0
            cellView.frame = CGRect(center: self.center, size: CGSize(width: size, height: size))
            super.frame = frame
        }
    }
    
    public var onHide: VoidAction? = nil
    
    override init(frame: CGRect) {
        oldFrame = .zero
        super.init(frame: frame)
        
        self.separate.frame = frame
        self.backgroundColor = .clear
        self.addSubview(separate)
        self.addSubview(cellView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(NKCellEditView.onGesture(sender:)))
        separate.addGestureRecognizer(gesture)
        
        let size = frame.width * 2.5 / 3.0
        cellView.frame = CGRect(center: self.center, size: CGSize(width: size, height: size))
        
    }
    
    public func show(frame: CGRect, duration: TimeInterval = 0.2) {
        
        oldFrame = frame
        cellView.isHidden = false
        cellView.alpha = fromAlpha
        
        let xScale = frame.width / (self.frame.width * 2.5 / 3.0)
        
        cellView.layer.cornerRadius = 10 / xScale
        cellView.transform = CGAffineTransform(scaleX: xScale, y: xScale)
        cellView.center = frame.center

        let newCenter = self.center
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            self?.cellView.transform = .identity
            self?.cellView.center = newCenter
            self?.cellView.alpha = 1.0
            self?.separate.alpha = 0.3
        })
        
    }
    
    @objc private func onGesture(sender: UITapGestureRecognizer) {
        self.hide()
    }
    
    public func hide(duration: TimeInterval = 0.25, completion: VoidAction? = nil) {
        
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let xScale = strongSelf.oldFrame.width / (strongSelf.frame.width * 2.5 / 3.0)
            
            strongSelf.cellView.transform = CGAffineTransform(scaleX: xScale, y: xScale)
            
            strongSelf.cellView.center = strongSelf.oldFrame.center
            strongSelf.separate.alpha = 0
            strongSelf.cellView.alpha = strongSelf.fromAlpha
        }, completion: { [weak self] _ in
            
            completion?()
            self?.onHide?()
            
            self?.cellView.hideAnimated {
                self?.removeFromSuperview()
            }
        })
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NKLog("NKCellEditView deinited")
    }
    
}
