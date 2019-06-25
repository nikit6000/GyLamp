//
//  NKLogger.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 25/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation

public func NKLog(_ items: Any...) {
    NKLogger.shared.log(items)
}

class NKLogger {
    
    public static let shared = NKLogger()
    
    
    public func log(_ items: [Any]) {
        
        #if DEBUG
        
        let processInfo = ProcessInfo.processInfo
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss:SSS"
        
        print("[\(processInfo.processName) \(dateFormatter.string(from: Date()))]: ", terminator: "")
        
        for item in items {
            print(item, terminator: " ")
        }
        
        print("")
        
        
        #endif
    
    }
    
}
