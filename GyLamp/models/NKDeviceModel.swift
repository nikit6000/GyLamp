//
//  NKDeviceModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 25/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import RxRelay
import SwiftSocket

typealias SelectAction = (_ index: Int) -> ()
typealias DeslectAction = (_ index: Int) -> ()

enum NKDeviceError: Int, LocalizedError {
    
    case noConnection = -1
    case noDataReaded
    case badDataReceived
    
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return NSLocalizedString("devError.noConnection", comment: "")
        case .noDataReaded:
            return NSLocalizedString("devError.noDataReaded", comment: "")
        case .badDataReceived:
            return NSLocalizedString("devError.badDataReceived", comment: "")
        }
    }
    
}

enum NKDeviceMode: Int {
    case confetti = 0
    case fire
    case rainbowV
    case rainbowH
    case fade
    case madness3D
    case cloud3D
    case lava3D
    case plasm3D
    case rainbow3D
    case peacock3D
    case zebra3D
    case forest3D
    case ocean3D
    case color
    case snow
    case matrix
    case fireflies
    
    var name: String {
        get {
            switch self {
            case .confetti:
                return NSLocalizedString("mode.confetti", comment: "")
            case .fire:
                return NSLocalizedString("mode.fire", comment: "")
            case .rainbowV:
                return NSLocalizedString("mode.rainbowV", comment: "")
            case .rainbowH:
                return NSLocalizedString("mode.rainbowH", comment: "")
            case .fade:
                return NSLocalizedString("mode.fade", comment: "")
            case .madness3D:
                return NSLocalizedString("mode.madness3D", comment: "")
            case .cloud3D:
                return NSLocalizedString("mode.cloud3D", comment: "")
            case .lava3D:
                return NSLocalizedString("mode.lava3D", comment: "")
            case .plasm3D:
                return NSLocalizedString("mode.plasm3D", comment: "")
            case .rainbow3D:
                return NSLocalizedString("mode.rainbow3D", comment: "")
            case .peacock3D:
                return NSLocalizedString("mode.peacock3D", comment: "")
            case .zebra3D:
                return NSLocalizedString("mode.zebra3D", comment: "")
            case .forest3D:
                return NSLocalizedString("mode.forest3D", comment: "")
            case .ocean3D:
                return NSLocalizedString("mode.ocean3D", comment: "")
            case .color:
                return NSLocalizedString("mode.color", comment: "")
            case .snow:
                return NSLocalizedString("mode.snow", comment: "")
            case .matrix:
                return NSLocalizedString("mode.matrix", comment: "")
            case .fireflies:
                return NSLocalizedString("mode.fireflies", comment: "")
            }
        }
    }
}

class NKDeviceModel: NSObject, ListDiffable {
    
    private(set) var ip: String
    private(set) var port: Int32
    private(set) var effects: [NKEffect]
    private(set) var mode: BehaviorRelay<NKDeviceMode?> = BehaviorRelay(value: nil)
    private(set) var isOnRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private(set) var errorRelay: BehaviorRelay<Error?> = BehaviorRelay(value: nil)
    
    private var disposeBag: DisposeBag
    private var currentMode: NKDeviceMode? = nil {
        willSet {
            if currentMode != nil {
                effects[currentMode!.rawValue].isSet = false
            }
            if newValue != nil {
                effects[newValue!.rawValue].isSet = true
            }
        }
    }
    
    
    public var isReachable: Bool
    public var name: String? = nil
    
    public var icon: UIImage
    
    public var isOn: Bool  {
        didSet {
            isOnRelay.accept(isOn)
        }
    }
    
    public var cSpeedRelay: BehaviorRelay<CGFloat>? {
        didSet {
            guard let observable = cSpeedRelay else {
                return
            }
            observable.flatMapLatest{ [weak self] value -> Observable<Void> in
                guard let strongSelf = self, let mode = strongSelf.mode.value else {
                    return .empty()
                }
                strongSelf.effects[mode.rawValue].speed = value
                
                NKLog(mode.name, "SPD", value)
                
                return strongSelf.send(cmd: "SPD", args: String(Int(value * 255)))
            }
            .subscribe(onNext: {
                NKLog("Value SPD setted")
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
            
            
        }
    }
    
    public var cScaleRelay: BehaviorRelay<CGFloat>? {
        didSet {
            guard let observable = cScaleRelay else {
                return
            }
            observable.flatMapLatest{ [weak self] value -> Observable<Void> in
                guard let strongSelf = self, let mode = strongSelf.mode.value else {
                    return .empty()
                }
                strongSelf.effects[mode.rawValue].scale = value
                
                return strongSelf.send(cmd: "SCA", args: String(Int(value * 255)))
                }
                .subscribe(onNext: {
                    NKLog("Value SCA setted")
                }, onError: { [weak self] error in
                    self?.errorRelay.accept(error)
                })
                .disposed(by: disposeBag)
        }
    }
   
    public var cBrightnessRelay: BehaviorRelay<CGFloat>? {
        didSet {
            guard let observable = cBrightnessRelay else {
                return
            }
            observable.flatMapLatest{ [weak self] value -> Observable<Void> in
                guard let strongSelf = self, let mode = strongSelf.mode.value else {
                    return .empty()
                }
                strongSelf.effects[mode.rawValue].brightness = value
                
                return strongSelf.send(cmd: "BRI", args: String(Int(value * 255)))
                }
                .subscribe(onNext: {
                    NKLog("Value BRI setted")
                }, onError: { [weak self] error in
                    self?.errorRelay.accept(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    
    init(ip: String, port: Int32 = 8888, isReachable: Bool = false) {
        self.ip = ip
        self.port = port
        self.icon = #imageLiteral(resourceName: "light.off")
        self.isReachable = isReachable
        self.effects = []
        self.disposeBag = DisposeBag()
        self.isOn = false
        for i in 0..<14 {
            effects.append(NKEffect(mode: NKDeviceMode(rawValue: i)!))
        }
        
        super.init()
        
        self.mode.asObservable()
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
                    .observeOn(MainScheduler.instance)
                    .flatMapLatest { [weak self] mode -> Observable<Void> in
                        guard let strongMode = mode, let strongSelf = self else {
                            return .empty()
                        }
                        
                        let index = strongMode.rawValue
                        strongSelf.currentMode = mode
                        
                        let effect = strongSelf.effects[index]
                        
                        effect.isLoading = true

                        
                        NKLog("Current mode:", strongMode.name)
                        return strongSelf.setMode(strongMode)
                    }
                    .subscribe(onNext: { [weak self] in
                        guard let strongSelf = self, let mode = strongSelf.currentMode else {
                            return
                        }
                        
                        let index = mode.rawValue
                        
                        
                        let effect = strongSelf.effects[index]
                        effect.isLoading = false
                        
                        strongSelf.cBrightnessRelay?.accept(effect.brightness)
                        strongSelf.cSpeedRelay?.accept(effect.speed)
                        strongSelf.cScaleRelay?.accept(effect.scale)
                        NKLog("Mode set on device")
                    }, onError: { [weak self] error in
                        guard let strongSelf = self, let mode = strongSelf.currentMode else {
                            return
                        }
                        
                        let index = mode.rawValue
                        
                        strongSelf.effects[index].isLoading = false
                        
                        self?.errorRelay.accept(error)
                    })
                    .disposed(by: disposeBag)
    }
    
    override init() {
        fatalError("Use different init")
    }
    
    
    func diffIdentifier() -> NSObjectProtocol {
        return "\(ip):\(port)" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKDeviceModel else {
            return false
        }
        
        return (self.ip == object.ip) && (self.port == object.port)
    }
    
    public func setMode(_ mode: NKDeviceMode) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            
            guard let client = NKUDPUtil.shared.connection else {
                observer.onError(NKDeviceError.noConnection)
                return Disposables.create()
            }
            
            guard let answ = client.send(cmd: "EFF", params: "\(mode.rawValue)") else {
                observer.onError(NKDeviceError.noDataReaded)
                return Disposables.create()
            }
            
            guard answ.starts(with: "CURR") else {
                observer.onError(NKDeviceError.badDataReceived)
                return Disposables.create()
            }
            
            let components = answ.split(separator: " ")
            
            if components.count < 2 {
                observer.onError(NKDeviceError.badDataReceived)
                return Disposables.create()
            }
            
            let mode: NKDeviceMode? = self?.mode.value
            
            for (index, component) in components.suffix(from: 1).enumerated() {
                
                guard let value = Int(component) else {
                    observer.onError(NKDeviceError.badDataReceived)
                    return Disposables.create()
                }
                
                switch index {
                case 1:
                    if let index = mode?.rawValue {
                        self?.effects[index].brightness = CGFloat(value) / 255.0
                    }
                    break
                case 2:
                    if let index = mode?.rawValue {
                        self?.effects[index].speed = CGFloat(value) / 255.0
                    }
                    break
                case 3:
                    if let index = mode?.rawValue {
                        self?.effects[index].scale = CGFloat(value) / 255.0
                    }
                    break
                case 4:
                    self?.isOn = (value != 0)
                default:
                    break
                }
            }
            
            
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        
        
    }
    
    public func send(cmd: String, args: String...) -> Observable<Void> {
        return Observable.create { observer in
            
            guard let client = NKUDPUtil.shared.connection else {
                observer.onError(NKDeviceError.noConnection)
                return Disposables.create()
            }
            
            guard let answ = client.sendCmd(cmd, params: args) else {
                observer.onError(NKDeviceError.noDataReaded)
                return Disposables.create()
            }
            
            NKLog("Received:", answ)
            
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }.subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
    }
    
    public func read() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            
            guard let client = NKUDPUtil.shared.connection else {
                observer.onError(NKDeviceError.noConnection)
                return Disposables.create()
            }
            
            guard let answ = client.send(cmd: "GET") else {
                observer.onError(NKDeviceError.noDataReaded)
                return Disposables.create()
            }
            
            NKLog("Received:", answ)
            
            let components = answ.split(separator: " ")
            
            if components.count < 2 {
                observer.onError(NKDeviceError.badDataReceived)
                return Disposables.create()
            }
            
            
            var mode: NKDeviceMode? = nil
            
            for (index, component) in components.suffix(from: 1).enumerated() {
                
                guard let value = Int(component) else {
                    observer.onError(NKDeviceError.badDataReceived)
                    return Disposables.create()
                }
                
                switch index {
                case 0:
                    mode = NKDeviceMode(rawValue: value)
                    self?.mode.accept(mode)
                    break
                case 1:
                    if let index = mode?.rawValue {
                        self?.effects[index].brightness = CGFloat(value) / 255.0
                    }
                    break
                case 2:
                    if let index = mode?.rawValue {
                        self?.effects[index].speed = CGFloat(value) / 255.0
                    }
                    break
                case 3:
                    if let index = mode?.rawValue {
                        self?.effects[index].scale = CGFloat(value) / 255.0
                    }
                    break
                case 4:
                    self?.isOn = (value != 0)
                default:
                    break
                }
            }
            
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }

}
