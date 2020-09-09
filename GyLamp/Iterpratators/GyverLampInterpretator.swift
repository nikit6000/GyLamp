//
//  GyverLampInterpretator.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 16/01/2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import Foundation
import UIKit
class GyverLampInterpretator: NKDeviceInterpretator {
    
    var gyverLampModel: NKDeviceModel? {
        return model as? NKDeviceModel
    }
    
    public func getAlarms() {
        send(cmd: "ALM_GET", onSuccess: nil, onError: nil)
    }
    
    public func get(onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        send(cmd: "GET", onSuccess: successBlock, onError: errorBlock)
    }
    
    override func set(mode: Int, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        let fullCmd = "EFF\(mode)"
        self.send(cmd: fullCmd, onSuccess: successBlock, onError: errorBlock)
    }
    
    override func set(state: NKDeviceState, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        switch state {
    
        case .off:
            self.send(cmd: "P_OFF", onSuccess: successBlock, onError: errorBlock)
        case .on:
            self.send(cmd: "P_ON", onSuccess: successBlock, onError: errorBlock)
        default:
            break
        }
    }
    
    override func process(answer: String) {
        
        if (answer.starts(with: "ALMS ")) {
            let index = answer.index(answer.startIndex, offsetBy: 5)
            
            let subStr = String(answer[index...])
            
            let splitResult = subStr.components(separatedBy: " ")
            
            if splitResult.count != 15 {
                return
            }
            
            for i in 0..<7 {
                guard let state = Int(splitResult[i]), let minutes = Int(splitResult[i + 7]) else {
                    return
                }
                
                guard let dawnModeStr = splitResult.last, let dawnMode = Int(dawnModeStr) else {
                    return
                }
                
                gyverLampModel?.alarms.alarmModels[i].isOn = state != 0
                gyverLampModel?.alarms.alarmModels[i].hours = minutes / 60
                gyverLampModel?.alarms.alarmModels[i].minutes = minutes % 60
                gyverLampModel?.alarms.alarmModels[i].dawnMode = dawnMode
                
            }
            
            
            
            model?.modelUpdatedSubject.onNext(())
        } else if (answer.starts(with: "CURR ")) {
            
            let index = answer.index(answer.startIndex, offsetBy: 5)
            
            let subStr = String(answer[index...])
            
            let splitResult = subStr.components(separatedBy: " ")
            
            if (splitResult.count != 5) {
                return
            }
            
            let mode = UInt(splitResult[0])
            let bri = Int(splitResult[1])
            let speed = Int(splitResult[2])
            let scale = Int(splitResult[3])
            let onFlag = Int(splitResult[4])
            
            guard mode != nil, bri != nil, speed != nil, scale != nil, onFlag != nil else {
                return
            }
            
            gyverLampModel?.isOn = onFlag! != 0
            
            
            
            if gyverLampModel?.sliders.sliders.count != 3 {
                return
            }
            
            gyverLampModel?.sliders.sliders[0].value = CGFloat(bri!) / 255.0
            gyverLampModel?.sliders.sliders[1].value = CGFloat(speed!) / 255.0
            gyverLampModel?.sliders.sliders[2].value = CGFloat(scale!) / 255.0
            
            if (mode! < gyverLampModel?.effects.models.count ?? 0) {
                
                gyverLampModel?.effects.models.enumerated().forEach {
                    
                    $1.isSet = ($0 == mode!)
                    $1.isLoading = false
                }
                
            }
            
            model?.modelUpdatedSubject.onNext(())
        } else if (answer.starts(with: "alm #")) {
        
            let startIndex = answer.index(answer.startIndex, offsetBy: 5)
            let subStr = String(answer[startIndex...])
            
            let splitResult = subStr.components(separatedBy: " ")
            
            guard let indexStr = splitResult.first, let state = splitResult.last, let index = Int(indexStr) else {
                return
            }
            
            if (index > 7 || index == 0)
            {
                return
            }
            
            if (state.contains("ON")) {
               gyverLampModel?.alarms.alarmModels[index - 1].isOn = true
            } else if (state.contains("OFF")) {
                gyverLampModel?.alarms.alarmModels[index - 1].isOn = false
            }
            
            gyverLampModel?.alarms.alarmModels[index - 1].isLoading = false
            
            model?.modelUpdatedSubject.onNext(())
        } else if (answer.starts(with: "DAWN")) {
            let startIndex = answer.index(answer.startIndex, offsetBy: 4)
            let subStr = String(answer[startIndex...])
            
            guard let dawnMode = Int(subStr) else {
                return
            }
            
            if (dawnMode < 0) {
                return
            }
            
            gyverLampModel?.alarms.alarmModels.forEach {
                
                $0.dawnMode = dawnMode - 1
                
            }
            
            model?.modelUpdatedSubject.onNext(())
        }
        
        NKLog("[GyverLampInterpretator] answer:", answer)
    }
    
}
