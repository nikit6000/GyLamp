//
//  NKAlarmModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 27/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxRelay

enum WeekDay: Int {
    case Monday = 0, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
    func getDayInNumber() -> Int {
        switch self {
        case .Monday:
            return 1
        case .Tuesday:
            return 2
        case .Wednesday:
            return 3
        case .Thursday:
            return 4
        case .Friday:
            return 5
        case .Saturday:
            return 6
        case .Sunday:
            return 7
        }
    }
    
    func getDay() -> String {
        switch self {
        case .Monday:
            return NSLocalizedString("week.monday", comment: "")
        case .Tuesday:
            return NSLocalizedString("week.tuesday", comment: "")
        case .Wednesday:
            return NSLocalizedString("week.wednesday", comment: "")
        case .Thursday:
            return NSLocalizedString("week.thursday", comment: "")
        case .Friday:
            return NSLocalizedString("week.friday", comment: "")
        case .Saturday:
            return NSLocalizedString("week.saturday", comment: "")
        case .Sunday:
            return NSLocalizedString("week.sunday", comment: "")
        }
    }
    
    func getDayShort() -> String {
        switch self {
        case .Monday:
            return NSLocalizedString("week.mon", comment: "")
        case .Tuesday:
            return NSLocalizedString("week.tue", comment: "")
        case .Wednesday:
            return NSLocalizedString("week.wed", comment: "")
        case .Thursday:
            return NSLocalizedString("week.thur", comment: "")
        case .Friday:
            return NSLocalizedString("week.fri", comment: "")
        case .Saturday:
            return NSLocalizedString("week.sat", comment: "")
        case .Sunday:
            return NSLocalizedString("week.sun", comment: "")
        }
    }
}

class NKAlarmModel: NSObject, ListDiffable {
    
    private(set) var day: WeekDay
    
    public weak var deviceModel: NKDeviceProtocol?
    
    public var hours: Int
    
    public var minutes: Int
    
    public var isOn: Bool
    
    public var isDawnEnabled: Bool
    
    public var hasError: Bool
    
    public var isLoading: Bool
    
    public var dawnMode: Int
    
    private let dawnMinutes = ["5", "10", "15", "20", "25", "30", "40", "50", "60"]
    
    public var dawnOffsetStr: String {
        
        if dawnMode >= dawnMinutes.count {
            dawnMode = 0
        }
        
        return dawnMinutes[dawnMode]
        
    }
    
    var hoursText: String {
        
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        
        
        
        if formatter.contains("a") {
            
            let date = self.date
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "h"
            
            return dateFormatter.string(from: date)
        } else {
            return String(format: "%.2d", hours)
        }
        
    }
    
    var minutesText: String {
        
        let minutes = String(format: "%.2d", self.minutes)
        
        return minutes
    }
    
    var amPm: String? {
        let locale = NSLocale.current
        
        guard let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale) else {
            return nil
        }
        
        if formatter.contains("a") {

            let date = self.date
                       
            let dateFormatter = DateFormatter()
           
            dateFormatter.dateFormat = "a"
            
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
    var date: Date {
        get {
            let time = String(format: "%.2d:%.2d", hours, minutes)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: time)!
            
            return date
        }
        set {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            hours = Int(dateFormatter.string(from: newValue))!
            
            dateFormatter.dateFormat = "mm"
            
            minutes = Int(dateFormatter.string(from: newValue))!
            
            
        }
    }
    
    var isTwentyHourFormat: Bool {
        let locale = NSLocale.current
        guard let formatter = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale) else {
            return false
        }
        
        return formatter.contains("a")
    }
    
    var setCmd: String {
        return "ALM_SET\(day.getDayInNumber())"
    }
    
    var dawnCmd: String {
        return "DAWN\(dawnMode + 1)"
    }
    
    init(day: WeekDay, h: Int, m: Int) {
        self.day = day
        self.hours = h
        self.minutes = m
        self.isOn = false
        self.isDawnEnabled = false
        self.hasError = false
        self.isLoading = false
        self.dawnMode = 0
        super.init()
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKAlarmModel else {
            return false
        }
        
        return  (object.minutes == self.minutes) &&
                (object.hours == self.hours) &&
                (object.day == self.day)
    }
    
    func from(min: Int, isOn: Bool) {
        
        self.hours = min / 60
        self.minutes = min % 60
        
        self.isOn = isOn
        
    }
    
    func from(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let components = dateFormatter.string(from: date).split(separator: ":")
        
        self.hours = Int(components.first!)!
        self.minutes = Int(components.last!)!
    }
    
    func absMins() -> Int {
        return hours * 60 + minutes
    }
    
    
}

class NKAlarmsModel: NSObject {
    
    public var alarmModels: [NKAlarmModel] = []
    
}

extension NKAlarmsModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
}
