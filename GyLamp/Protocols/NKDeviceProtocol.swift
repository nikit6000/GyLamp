//
//  NKDeviceProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 16/01/2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol NKDeviceProtocol: class {
    
    var modelUpdatedSubject: PublishSubject<Void> { get }
    var interpretatator: NKDeviceInterpretator { get }
    
}
