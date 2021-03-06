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
    
    public var data: Data? {
        return fullComand?.data(using: .ascii)
    }
    
    
    
}
