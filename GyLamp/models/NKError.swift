//
//  NKError.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 09/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation

class NKEntityError: NSError {
    
    init(entityName: String, userInfo: [String : Any]? = nil) {
        
        let domain = NSLocalizedString("error.entityError", comment: "") + " " +   entityName
        
        super.init(domain: domain, code: -1, userInfo: userInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
