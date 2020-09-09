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
import CoreData
import SwiftyXML

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

class NKDeviceModel: NKModel, NKDeviceProtocol {
    
    
    private(set) var ip: String
    private(set) var port: Int32
    
    
    public var isReachable: Bool =  false
    public var icon: UIImage
    public var isOn: Bool
    public var isBusy: Bool = false
    
    public var modelUpdatedSubject = PublishSubject<Void>()
    
    private(set) var lampInterpretator: GyverLampInterpretator
    private(set) var sliders = NKSlidersModel()
    private(set) var alarms = NKAlarmsModel()
    private(set) var effects = NKEffects()
    
    public var interpretatator: NKDeviceInterpretator {
        return lampInterpretator as NKDeviceInterpretator
    }
    
    public var name: String? = nil {
        didSet{
            update()
        }
    }
    
    override class var entityName: String {
        return "Device"
    }

    override var searchPredicate: NSPredicate {
        return NSPredicate(format: "ip = %@ AND port = %d", ip, port)
    }
    
    override var managedObject: NSManagedObject? {
        didSet {
            update()
        }
    }
    
    init(ip: String, port: Int32 = 8888, isReachable: Bool = false) {
        self.ip = ip
        self.port = port
        self.icon = #imageLiteral(resourceName: "light.off")
        self.isReachable = isReachable
        self.isOn = false
        
        lampInterpretator = GyverLampInterpretator(address: ip, port: port)
        
        super.init()
        
        lampInterpretator.model = self
        makeModels()
        
        for i in 0..<18 {
            let effect = NKDeviceMode(rawValue: i)!
            
            let efferctModel = NKEffect(mode: effect.name)
            
            efferctModel.deviceModel = self
            
            effects.models.append(efferctModel)
        }
    }
    
    private func makeModels() {
        
        if (sliders.sliders.count > 0)
        {
            sliders.sliders.removeAll()
        }
        
        if (alarms.alarmModels.count > 0)
        {
            alarms.alarmModels.removeAll()
        }
        
        let sliderBRI = NKSliderModel(cmd: "BRI", min: 0.0, max: 255.0, type: .int)
        let sliderSPD = NKSliderModel(cmd: "SPD", min: 0.0, max: 255.0, type: .int)
        let sliderSCA = NKSliderModel(cmd: "SCA", min: 0.0, max: 255.0, type: .int)
        
        sliderBRI.model = self
        sliderSPD.model = self
        sliderSCA.model = self
        
        sliders.sliders.append(sliderBRI)
        sliders.sliders.append(sliderSPD)
        sliders.sliders.append(sliderSCA)
        
        for i in 0..<7 {
            
            let alarm = NKAlarmModel(day: WeekDay(rawValue: i)!, h: 0, m: 0)
            
            alarm.deviceModel = self
            
            alarms.alarmModels.append(alarm)
        }
            
    }
    
    override init() {
        fatalError("Use different init")
    }
    
    required init?(xml: XML) {
        
        
        guard let xmlns = xml.$xmlns.string, xmlns.starts(with: "urn:schemas-upnp-org") == true else {
            return nil
        }
        
        let device = xml.device
        let modes = xml.modes
        
        guard let urlBase = xml.URLBase.string, let host = URL(string: urlBase)?.host else {
            return nil
        }
        
        guard let modelNumber = device.modelNumber.string else {
            return nil
        }
        
        if (modelNumber != "00004F790C92") {
            return nil
        }
        
        self.name = device.friendlyName.string
        self.port = 8888
        self.ip = host
        self.icon = #imageLiteral(resourceName: "light.off")
        self.isOn = false
        
        lampInterpretator = GyverLampInterpretator(address: self.ip, port: self.port)
        
        super.init()
        
        lampInterpretator.model = self
        makeModels()
        
        for name in modes.value {
            
            guard let name = name.string else {
                break
            }
            
            let model = NKEffect(mode: name)
            model.deviceModel = self
            
            effects.models.append(model)
        }
    }
    
    required init?(with managedObject: NSManagedObject) {
        
        let ip = managedObject.value(forKey: "ip") as? String
        let port = managedObject.value(forKey: "port") as? Int32
        let name = managedObject.value(forKey: "name") as? String
        let modes = managedObject.value(forKey: "modes") as? [String]
        
        guard ip != nil, port != nil else {
            return nil
        }
        
        self.ip = ip!
        self.port = port!
        self.name = name
        self.icon = #imageLiteral(resourceName: "light.off")
        self.isOn = false
        
        lampInterpretator = GyverLampInterpretator(address: ip!, port: port!)
        
        super.init(with: managedObject)
        
        lampInterpretator.model = self
        makeModels()
        
        modes?.forEach {
            let effect = NKEffect(mode: $0)
            effect.deviceModel = self
            effects.models.append(effect)
        }
    }
    
    
    override func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    override func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKDeviceModel else {
            return false
        }
        
        return (self.ip == object.ip) && (self.port == object.port)
    }

    
    public func copy() -> NKDeviceModel {
        return NKDeviceModel(ip: ip, port: port, isReachable: isReachable)
    }
    
    private func update() {
        
        guard let managedObject = self.managedObject else {
            return
        }
        
        let modes = effects.models.map {
            return $0.mode
        }
        
        managedObject.setValue(ip, forKey: "ip")
        managedObject.setValue(port, forKey: "port")
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(modes, forKey: "modes")
    }

    deinit {
        NKLog("[NKDeviceModel] - deinit")
    }
}

