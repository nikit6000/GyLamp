//
//  NKAdModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 12.05.2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import IGListKit
import GoogleMobileAds

class NKAdModel: NSObject {
    
    public var _id: String
    
    public var options: [GADAdLoaderOptions]
    public var isTesting: Bool
    
    public class var testId: String {
        return ""
    }
    
    public var id: String {
        return (isTesting || _id.isEmpty) ? NKAdModel.testId : _id
    }
    
    public var type: GADAdLoaderAdType {
        return .customNative
    }
    
    init(ad id: String, with options: [GADAdLoaderOptions] = [], isTesting: Bool = false) {
        
        self._id = id
        self.options = options
        self.isTesting = isTesting
        
        super.init()
    }
}

extension NKAdModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
    
    
}
