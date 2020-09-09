//
//  SSDPUtil.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 20/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXML
import RxRelay
import RxSwift


class SSDPUtil {
    
    public static let shared = SSDPUtil()

    func getDevice(description url: URL) -> Observable<NKDeviceModel> {
        return Observable.create { observer in
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseString(completionHandler: { response in
                
                guard response.error == nil else {
                    observer.onError(response.error!)
                    return
                }
                
                if let xml = XML(data: response.data!), let model = NKDeviceModel(xml: xml) {
                    observer.onNext(model)
                }
                
                observer.onCompleted()
                
            })
            
            return Disposables.create()
        }
    }
    
}
