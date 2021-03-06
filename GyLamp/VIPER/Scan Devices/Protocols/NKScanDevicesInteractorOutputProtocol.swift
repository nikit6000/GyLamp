//
//  NKScanDevicesInteractorOutputProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

protocol NKScanDevicesInteractorOutputProtocol: class {
    
    func dataReady(_ data: [ListDiffable])
    func storedSectionReady(_ deviceModels: [ListDiffable])
    func scanDevicesFounded(_ deviceModels: [ListDiffable])
    func errorHandler(_ error: Error)
    
    func needUpdate(sectionFor item: ListDiffable)
    func manualModelReady(model: NKDeviceModel)
    func presentGyverLampBeta()
}
