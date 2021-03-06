//
//  NKNativeAdModel.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 12.05.2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import IGListKit
import GoogleMobileAds

class NKNativeAdModel: NKAdModel {
    
    override class var testId: String {
        fatalError("ERROR! Do not use test ads in realise mode")
        //return "ca-app-pub-3940256099942544/3986624511"
    }
    
    public override var id: String {
        return (isTesting || _id.isEmpty) ? NKNativeAdModel.testId : _id
    }
    
    override var type: GADAdLoaderAdType {
        return .customNative
    }
    
}
