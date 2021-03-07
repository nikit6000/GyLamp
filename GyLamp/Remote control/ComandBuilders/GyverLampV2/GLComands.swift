//
//  GLComands.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 31.01.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

//MARK: - Control comands

//MARK: Set power comand

class GLComandSetPower: GLComand {
    
    var state: UInt8
    
    override var payload: NKStringComand? {
        return GLArrayComand(with: state)
    }
    
    init(isOn: Bool) {
        self.state = isOn ? 1 : 0
        super.init(type: .control)
    }
    
}

//MARK: Minimum and Maximum brightness comand

enum GLBrightnessAbsLevel: UInt {
    case min = 2
    case max = 3
}

class GLComandSetBrightness: GLComand {
    
    var brightnessAbsLevel: GLBrightnessAbsLevel
    
    override var payload: NKStringComand? {
        return GLArrayComand(with: brightnessAbsLevel.rawValue)
    }
    
    init(level: GLBrightnessAbsLevel) {
        self.brightnessAbsLevel = level
        super.init(type: .control)
    }
    
}

//MARK: Preset discrete change comand

enum GLChangePresetDirection: UInt8 {
    case prev = 4
    case next = 5
    case custom = 6
}

class GLComandPresetChange: GLComand {
    
    var direction: GLChangePresetDirection
    var index: UInt8?
    
    override var payload: NKStringComand? {
        
        var data: [UInt8] = []
        
        data.append(direction.rawValue)
        
        if (index != nil) {
            data.append(index!)
        }
        
        return GLArrayComand(withElements: data)
    }
    
    init(direction: GLChangePresetDirection) {
        self.direction = direction
        self.index = nil
        super.init(type: .control)
    }
    
    init(index: UInt8) {
        self.direction = .custom
        self.index = index
        super.init(type: .control)
    }
    
}

//MARK: Set wifi mode comand

enum GLWifiMode: UInt8 {
    case ap = 0
    case local = 1
}

class GLSetWifiMode: GLComand {
    
    var mode: GLWifiMode
    
    override var payload: NKStringComand? {
        var data: [UInt8] = []
        
        data.append(7) // Comand id is 8
        data.append(mode.rawValue)
        
        return GLArrayComand(withElements: data)
    }
    
    init(mode: GLWifiMode) {
        self.mode = mode
        super.init(type: .control)
    }
}

//MARK: Set role comand

enum GLRole: UInt8 {
    case slave = 0
    case master = 1
}

class GLSetRole: GLComand {
    
    var role: GLRole
    
    override var payload: NKStringComand? {
        let comandId: UInt8 = 8
        return GLArrayComand(withElements: [comandId, role.rawValue])
    }
    
    init(role: GLRole) {
        self.role = role
        super.init(type: .control)
    }
    
}

//MARK: Set group comand

class GLSetGroup: GLComand {
    
    var group: UInt16
    
    override var payload: NKStringComand? {
        let comandId: UInt16 = 9
        return GLArrayComand(withElements: [comandId, group])
    }
    
    init(group: UInt16) {
        self.group = group
        super.init(type: .control)
    }
    
}

//MARK: Wifi connect comand

class GLWiFiConnect: GLComand {
    
    var ssid: String
    var password: String?
    
    init(ssid: String, password: String? = nil) {
        self.ssid = ssid
        self.password = password
        super.init(type: .control)
    }
    
}

//MARK: Wifi reset comand

class GLWiFiReset: GLComand {
    
    override var payload: NKStringComand? {
        let comandId: UInt8 = 11
        return GLArrayComand(with: comandId)
    }
    
    init() {
        super.init(type: .control)
    }
    
}

//MARK: Update comand

class GLUpdate: GLComand {
    
    override var payload: NKStringComand? {
        let comandId: UInt8 = 12
        return GLArrayComand(with: comandId)
    }
    
    init() {
        super.init(type: .control)
    }
    
}

//MARK: Update comand

class GLSetTurnOffTimer: GLComand {
    
    var turnOffTime: UInt8
    
    override var payload: NKStringComand? {
        let comandId: UInt8 = 13
        return GLArrayComand(withElements: [comandId, turnOffTime])
    }
    
    init(turnOffTime: UInt8) {
        self.turnOffTime = turnOffTime
        super.init(type: .control)
    }
    
}

//MARK: - Config comands

struct GLConfig {
    var bright: UInt8
    var adcMode: UInt8
    var minBright: UInt8
    var maxBright: UInt8
    var presetChangeMode: UInt8
    var randomMode: UInt8
    var changePeriod: UInt8
    var deviceType: UInt8
    var maxCurrent: UInt8
    var workSince: UInt8
    var workUntill: UInt8
    var matrixOrientation: UInt8
    var length: UInt16
    var width: UInt16
    var GTM: UInt8
    var cityId: UInt32
    var mqttState: UInt8
    var mqttId: String
    var mqttHost: String
    var mqttPort: UInt16
    var mqttLogin: String
    var mqttPass: String
}

class GLSetCfg: GLComand {
    
    var config: GLConfig
    
    override var payload: NKStringComand? {
    
        let packetCmd = GLArrayComand()
        
        packetCmd.append(config.bright)
        packetCmd.append(config.adcMode)
        packetCmd.append(config.minBright)
        packetCmd.append(config.maxBright)
        packetCmd.append(config.presetChangeMode)
        packetCmd.append(config.randomMode)
        packetCmd.append(config.changePeriod)
        packetCmd.append(config.deviceType)
        packetCmd.append(config.maxCurrent)
        packetCmd.append(config.workSince)
        packetCmd.append(config.workUntill)
        packetCmd.append(config.matrixOrientation)
        packetCmd.append(config.length)
        packetCmd.append(config.width)
        packetCmd.append(config.GTM)
        packetCmd.append(config.cityId)
        packetCmd.append(config.mqttState)
        packetCmd.append(config.mqttId)
        packetCmd.append(config.mqttHost)
        packetCmd.append(config.mqttPort)
        packetCmd.append(config.mqttLogin)
        packetCmd.append(config.mqttPass)
       
        return packetCmd
        
    }
    
    init(config: GLConfig) {
        self.config = config
        super.init(type: .config)
    }
    
}

//MARK: - Preset comands

struct GLPreset {
    var effect: UInt8
    var lowBrightness: UInt8
    var customBright: UInt8
    var soundMode: UInt8
    var soundReactionType: UInt8
    var minSignal: UInt8
    var maxSignal: UInt8
    var speed: UInt8
    var palette: UInt8
    var scale: UInt8
    var fromCenter: UInt8
    var color: UInt8
    var random: UInt8
}

class GLSetPreset: GLComand {
    
    var presets: [GLPreset]
    
    override var payload: NKStringComand? {
        
        let presetsCount = UInt8(presets.count)
        var combinedData: [UInt8] = [presetsCount]
        
        
        for i in 0..<Int(presetsCount) {
            let packedData = Data(bytes: &presets[i], count: MemoryLayout<GLPreset>.size)
            let packedBytes = [UInt8](packedData)
            combinedData.append(contentsOf: packedBytes)
        }
        
        return GLArrayComand(withElements: combinedData)
        
    }
    
    init(presets: [GLPreset]) {
        self.presets = presets
        super.init(type: .effects)
    }
    
}

//MARK: - Dawn comands

struct GLDawnDayRaw {
    var day: UInt8
    var timeInSeconds: UInt
    var isEnabled: Bool
}

class GLDawnConfig {
    
    public var dawnDays: [GLDawnDayRaw]
    
    public var bright: Float
    public var minutesUntillDawn: UInt8
    
    public var packed: [UInt8] {
        return self.pack()
    }
    
    init(days: [GLDawnDayRaw], brightness: Float, minutesUntillDawn: UInt8) {
        self.dawnDays = days
        self.bright = brightness
        self.minutesUntillDawn = minutesUntillDawn
    }
    
    private func pack() -> [UInt8] {
        var state: [UInt8] = []
        var hours: [UInt8] = []
        var minutes: [UInt8] = []
        var data: [UInt8] = []
        
        dawnDays.forEach {
            let hour = $0.timeInSeconds / 3600
            let minute = ($0.timeInSeconds - hour * 3600) / 60
            let isEnabled = UInt8($0.isEnabled ? 1 : 0)
            
            hours.append(UInt8(hour))
            minutes.append(UInt8(minute))
            state.append(isEnabled)
            
        }
        
        data.append(contentsOf: state)
        data.append(contentsOf: hours)
        data.append(contentsOf: minutes)
        
        data.append(UInt8(bright * 255.0))
        data.append(minutesUntillDawn)
        
        return data
    }
}

class GLSetDawn: GLComand {
    
    var config: GLDawnConfig
    
    override var payload: NKStringComand? {
        return GLArrayComand(withElements: config.packed)
    }
    
    init(config: GLDawnConfig) {
        self.config = config
        super.init(type: .dawn)
    }
    
}
