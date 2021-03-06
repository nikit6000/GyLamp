//
//  GLPresetModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import CoreData

@objc enum GLPresetEffectType: Int16, CaseIterable, CustomStringConvertible {
    case perlin = 1
    case color = 2
    case transition = 3
    case gradient = 4
    case fragments = 5
    case fire = 6
    
    var description: String {
        let localizedKey = String(format: "GLPresetModel.EffectType.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
}

@objc enum GLPresetSoundType: Int16, CaseIterable, CustomStringConvertible {
    case none = 1
    case volume = 2
    case lowFrequency = 3
    case highFrequency = 4
    
    var description: String {
        let localizedKey = String(format: "GLPresetModel.SoundType.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
}

@objc enum GLPresetSoundReaction: Int16, CaseIterable, CustomStringConvertible {
    case brightness = 1
    case scale = 2
    case length = 3
    
    var description: String {
        let localizedKey = String(format: "GLPresetModel.SoundReaction.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
}

@objc enum GLPresetPalette: Int16, CaseIterable, CustomStringConvertible {
    case warm = 1
    case fire = 2
    case lava
    case party
    case rainbow
    case clouds
    case ocean
    case sunset
    case police
    case optimusPrime
    case warmLava
    case coldLava
    case hotLava
    case pinkLava
    case comfort
    case cyberpunk
    case forGirls
    case christmas
    case toxic
    case blueSmoke
    case bubleGum
    case leopard
    case aurora
    
    var description: String {
        let localizedKey = String(format: "GLPresetModel.Palette.%d.name", self.rawValue)
        return NSLocalizedString(localizedKey, comment: "")
    }
    
}

@objc(GLPresetModel)
final class GLPresetModel: NSManagedObject {
    
    var packed: GLPreset {
    
        return self.pack()
    }
    
    private func pack() -> GLPreset {
        return GLPreset(effect: UInt8(effectType.rawValue),
                        lowBrightness: lowBrightnessEnabled ? 1 : 0,
                        customBright: UInt8(255.0 * customBrightness),
                        soundMode: UInt8(soundType.rawValue),
                        soundReactionType: UInt8(soundReaction.rawValue),
                        minSignal: UInt8(255.0 * minSignal),
                        maxSignal: UInt8(255.0 * maxSignal),
                        speed: UInt8(255.0 * speed),
                        palette: UInt8(palette.rawValue),
                        scale: UInt8(255.0 * scale),
                        fromCenter: centered ? 1 : 0,
                        color: UInt8(255.0 * color),
                        random: random ? 1 : 0)
    }
}
