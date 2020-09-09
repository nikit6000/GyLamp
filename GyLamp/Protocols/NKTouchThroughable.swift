//
//  NKTouchThroughable.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10.05.2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import UIKit

protocol NKTouchThroughable: class {
    
    func subviewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func subviewTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func subviewTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    func subviewTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
}
