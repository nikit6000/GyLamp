//
//  NKComandBuilder.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 31.01.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

protocol NKRawComand {
    var data: Data? { get }
}

class NKStringComand: NKRawComand {
    
    public var payload: NKStringComand? {
        return nil
    }
    
    public var comand: String? {
        fatalError("Calling generic function")
    }
    
    public var fullComand: String? {
        
        guard var comand = self.comand else {
            return nil
        }
        
        if let payloadData = self.payload?.fullComand {
            comand += "," + payloadData
        }
        
        return comand
    }
    
    public var fullComandFollowedByTime: String? {
        guard let fullComand = fullComand else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        let now = Date()
        let calendar = Calendar.current
        
        //Gregorian calendar starts with Sunday
        var weekDay = calendar.component(.weekday, from: now) - 1
        
        if weekDay == 0 {
            weekDay = 7
        }
        
        dateFormatter.dateFormat = "H,m,s"
        
        return "\(fullComand),\(weekDay),\(dateFormatter.string(from: now))"
        
    }
    
    public var data: Data? {
        return fullComandFollowedByTime?.data(using: .ascii)
    }
    
    
    
}
