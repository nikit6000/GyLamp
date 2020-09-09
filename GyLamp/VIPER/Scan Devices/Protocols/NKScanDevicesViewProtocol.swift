//
//  NKScanDevicesViewProtocol.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit

protocol NKScanDevicesViewProtocol: class {
    
    func show(data: [ListDiffable], animated: Bool)
    func updateSection(for item: ListDiffable, animated: Bool) 
    
}
