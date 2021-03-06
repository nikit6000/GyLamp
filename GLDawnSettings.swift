//
//  GLDawnSettings+CoreDataClass.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GLDawnSettings)
public class GLDawnSettings: NSManagedObject {

    var rawConfig: GLDawnConfig {
        return toConfig()
    }
    
    public func set(enabled: Bool, at day: WeekDay? = nil) {
        
        guard days != nil else {
            return
        }
        
        if let strongDay = day, let index = days!.firstIndex(where: { $0.day == strongDay.rawValue }) {
            days![index].isEnabled = enabled
        } else {
            days!.indices.forEach {
                days![$0].isEnabled = enabled
            }
        }
    }
    
    public func set(time: Int32, at day: WeekDay? = nil) {
        
        guard days != nil else {
            return
        }
        
        if let strongDay = day, let index = days!.firstIndex(where: { $0.day == strongDay.rawValue }) {
            days![index].timeInSeconds = time
        } else {
            days!.indices.forEach {
                days![$0].timeInSeconds = time
            }
        }
    }
    
    public func set(hours: Int32, minutes: Int32, at day: WeekDay? = nil) {
        set(time: 60 * hours * minutes, at: day)
    }
    
    public override func awakeFromInsert() {
        
        //super.awakeFromInsert()
        
        if (self.managedObjectContext!.parent != nil) {
            
            var days: [GLDawnDay] = []
            
            for day in 0...6 {
                
                let dawnDay = GLDawnDay(context: self.managedObjectContext!)
                
                dawnDay.day = Int16(day)
                dawnDay.isEnabled = false
                dawnDay.timeInSeconds = 0
            
                days.append(dawnDay)
            }
        
            self.days = Set(days)
        }
        
    }
    
    private func toConfig() -> GLDawnConfig {
        
        let rawDays: [GLDawnDayRaw]
    
        if let days = self.days {
            rawDays = days.sorted { $0.day < $1.day }.map { $0.rawValue }
        } else {
            rawDays = (0...6).map { GLDawnDayRaw(day: UInt8($0), timeInSeconds: 0, isEnabled: false) }
        }
        
        return GLDawnConfig(days: rawDays, brightness: brightness, minutesUntillDawn: UInt8(minutesUntilDawn))
    }
    
}
