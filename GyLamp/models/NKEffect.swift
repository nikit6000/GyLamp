//
//  NKEffect.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxRelay
import RxSwift

class NKEffect: NSObject, ListDiffable {
    
    private(set) var mode: NKDeviceMode
    
    public var speed: CGFloat {
        didSet {
            speedRelay.accept(speed)
        }
    }
    
    public var scale: CGFloat {
        didSet {
            scaleRelay.accept(scale)
        }
    }
    
    public var brightness: CGFloat {
        didSet {
            brightnessRelay.accept(brightness)
        }
    }
    
    public var isSet: Bool {
        didSet {
            isSetRelay.accept(isSet)
        }
    }
    
    public var isLoading: Bool {
        didSet {
            isLoadingRelay.accept(isLoading)
        }
    }
    
    private(set) var isSetRelay: BehaviorRelay<Bool>
    private(set) var isLoadingRelay: BehaviorRelay<Bool>
    private(set) var speedRelay: BehaviorRelay<CGFloat>
    private(set) var scaleRelay: BehaviorRelay<CGFloat>
    private(set) var brightnessRelay: BehaviorRelay<CGFloat>
    
    init(mode: NKDeviceMode) {
        self.mode = mode
        self.isSetRelay = BehaviorRelay(value: false)
        self.speedRelay = BehaviorRelay(value: 0)
        self.brightnessRelay = BehaviorRelay(value: 0)
        self.scaleRelay = BehaviorRelay(value: 0)
        self.isLoadingRelay = BehaviorRelay(value: false)
        
        self.isSet = false
        self.isLoading = false
        self.speed = 0
        self.scale = 0
        self.brightness = 0
        
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKEffect else {
            return false
        }
        
        return  (self.speed == object.speed) &&
                (self.scale == object.scale) &&
                (self.brightness == object.brightness)
    }
    
    
}
