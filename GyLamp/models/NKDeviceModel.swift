//
//  NKDeviceModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 25/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

/*enum NKDeviceMode: Int {
 
}*/

class NKDeviceModel: NSObject, ListDiffable {
    
    private(set) var ip: String
    private(set) var port: Int32
    
    
    
    
    init(ip: String, port: Int32 = 8888) {
        self.ip = ip
        self.port = port
        super.init()
    }
    
    override init() {
        fatalError("Use different init")
    }
    
    
    func diffIdentifier() -> NSObjectProtocol {
        return "\(ip):\(port)" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? NKDeviceModel else {
            return false
        }
        
        return (self.ip == object.ip) && (self.port == object.port)
    }

}
