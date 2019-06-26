//
//  UDPClient+extension.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import SwiftSocket


extension UDPClient {
    
    func sendCmd(_ cmd: String, params: [String]?) -> String? {
        
        let comand:String
        
        if params != nil {
            comand = cmd + params!.joined(separator: " ")
        } else {
            comand = cmd
        }
        
        let status = self.send(string: comand)
        
        switch status {
        case .success:
            let received = self.recv(512)
            
            guard let data = received.0, let responseStr = String(bytes: data, encoding: .utf8) else {
                return nil
            }
            
            return responseStr
        case .failure(_):
            return nil
        }
        
    }
    
    func send(cmd: String, params: String...) -> String? {
        return sendCmd(cmd, params: params)
    }
    
    func send(cmd: String) -> String? {
        return sendCmd(cmd, params: nil)
    }
    
}
