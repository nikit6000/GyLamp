//
//  GLSettingsModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import CoreData
import CoreStore


@objc enum GLSettingsNTPServer: Int16, CaseIterable, ListEnumStringConvertable, AllowedObjectiveCKeyPathValue {
    typealias DestinationValueType = Int16
    
    
    case server1 = 1
    case server2 = 2
    case server3
    case server4
    case server5
    
    var description: String {
        let localizedKey = String(format: "GLSettingsModel.NPTServer.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
    
    var allCasesAsString: [String] {
        return type(of: self).allCases.map { $0.description }
    }
    
    var allCasesRawValue: [Int16] {
        return type(of: self).allCases.map { $0.rawValue }
    }
}

@objc enum GLSettingsADCMode: Int16, CaseIterable, ListEnumStringConvertable, AllowedObjectiveCKeyPathValue {
    typealias DestinationValueType = Int16
    
    
    case none = 1
    case brightness = 2
    case lightMusic
    
    var description: String {
        let localizedKey = String(format: "GLSettingsModel.ADCMode.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
    
    var allCasesAsString: [String] {
        return type(of: self).allCases.map { $0.description }
    }
    
    var allCasesRawValue: [Int16] {
        return type(of: self).allCases.map { $0.rawValue }
    }
}

@objc enum GLSettingsPresetChangeMode: Int16, CaseIterable, ListEnumStringConvertable, AllowedObjectiveCKeyPathValue {
    typealias DestinationValueType = Int16
    
    
    case manual = 0
    case auto = 1
    
    var description: String {
        let localizedKey = String(format: "GLSettingsModel.PresetChangeMode.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
    
    var allCasesAsString: [String] {
        return type(of: self).allCases.map { $0.description }
    }
    
    var allCasesRawValue: [Int16] {
        return type(of: self).allCases.map { $0.rawValue }
    }
}

@objc enum GLSettingsLampType: Int16, CaseIterable, ListEnumStringConvertable, AllowedObjectiveCKeyPathValue {
    typealias DestinationValueType = Int16
    
    
    case strip = 1
    case zigZag = 2
    case spiral = 3
    
    var description: String {
        let localizedKey = String(format: "GLSettingsModel.LampType.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
    
    var allCasesAsString: [String] {
        return type(of: self).allCases.map { $0.description }
    }
    
    var allCasesRawValue: [Int16] {
        return type(of: self).allCases.map { $0.rawValue }
    }
}

@objc enum GLSettingsChangePeriod: Int16, CaseIterable, ListEnumStringConvertable, AllowedObjectiveCKeyPathValue {
    typealias DestinationValueType = Int16
    
    
    case one = 1
    case five = 5
    case ten = 10
    case fifteen = 15
    case twentyFive = 25
    case thirty = 30
    case forty = 40
    case fifty = 50
    case sixty = 60
    
    var description: String {
        let localizedKey = String(format: "GLSettingsModel.changePeriod.fmt", self.rawValue)
        return String(format: NSLocalizedString(localizedKey, comment: ""), self.rawValue)
    }
    
    var allCasesAsString: [String] {
        return type(of: self).allCases.map { $0.description }
    }
    
    var allCasesRawValue: [Int16] {
        return type(of: self).allCases.map { $0.rawValue }
    }
}

@objc enum GLSettingsOrientation: Int16, CaseIterable, ListEnumStringConvertable, AllowedObjectiveCKeyPathValue {
    typealias DestinationValueType = Int16
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    
    var description: String {
        let localizedKey = String(format: "GLSettingsModel.orientation.fmt", self.rawValue)
        return String(format: NSLocalizedString(localizedKey, comment: ""), self.rawValue)
    }
    
    var allCasesAsString: [String] {
        return type(of: self).allCases.map { $0.description }
    }
    
    var allCasesRawValue: [Int16] {
        return type(of: self).allCases.map { $0.rawValue }
    }
}

@objc(GLSettingsModel)
final class GLSettingsModel: NSManagedObject {
    
    var packed: GLConfig {
        return self.pack()
    }
    
    private func pack() -> GLConfig {
        NKLog(brightness)
        return GLConfig(bright: UInt8(brightness),
                        adcMode: UInt8(adcMode.rawValue),
                        minBright: UInt8(minBrightness),
                        maxBright: UInt8(maxBrigtness),
                        presetChangeMode: UInt8(modeChange.rawValue),
                        randomMode: random ? 1 : 0,
                        changePeriod: UInt8(changePeriod.rawValue),
                        deviceType: UInt8(lampType.rawValue),
                        maxCurrent: UInt8(maxCurrent / 100),
                        workSince: UInt8(workTimeSince),
                        workUntill: UInt8(workTimeUntil),
                        matrixOrientation: UInt8(matrixOrientation.rawValue),
                        length: length,
                        width: width,
                        GTM: UInt8(timeZone + 13),
                        cityId: cityId,
                        mqttState: mqttState ? 1 : 0,
                        mqttId: mqttId,
                        mqttHost: mqttHost,
                        mqttPort: mqttPort,
                        mqttLogin: mqttLogin,
                        mqttPass: mqttPass)
    }
    
}

extension PartialKeyPath: PartialKeyPathStringConvertable where Root == GLSettingsModel {
    
    var stringValue: String {
        switch self {
        case \GLSettingsModel.timeZone:
            return "timeZone"
        case \GLSettingsModel.cityId:
            return "cityId"
        case \GLSettingsModel.brightness:
            return "brightness"
        case \GLSettingsModel.adcMode:
            return "adcMode"
        case \GLSettingsModel.minBrightness:
            return "minBrightness"
        case \GLSettingsModel.maxBrigtness:
            return "maxBrigtness"
        case \GLSettingsModel.maxCurrent:
            return "maxCurrent"
        case \GLSettingsModel.modeChange:
            return "modeChange"
        case \GLSettingsModel.random:
            return "random"
        case \GLSettingsModel.changePeriod:
            return "changePeriod"
        case \GLSettingsModel.lampType:
            return "lampType"
        case \GLSettingsModel.maxCurrent:
            return "maxCurrent"
        case \GLSettingsModel.workTimeSince:
            return "workTimeSince"
        case \GLSettingsModel.workTimeUntil:
            return "workTimeUntil"
        case \GLSettingsModel.length:
            return "length"
        case \GLSettingsModel.width:
            return "width"
        case \GLSettingsModel.mqttId:
            return "mqttId"
        case \GLSettingsModel.mqttHost:
            return "mqttHost"
        case \GLSettingsModel.mqttPort:
            return "mqttPort"
        case \GLSettingsModel.mqttPass:
            return "mqttPass"
        case \GLSettingsModel.mqttState:
            return "mqttState"
        case \GLSettingsModel.mqttLogin:
            return "mqttLogin"
        case \GLSettingsModel.matrixOrientation:
            return "matrixOrientation"
        default:
            fatalError("Unexpected key path")
        }
    }
}
