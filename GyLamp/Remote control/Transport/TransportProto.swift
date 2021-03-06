//
//  TransportProto.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation

typealias TransportHandler = (_ data: Data?, _ error: Error?) -> ()
typealias TransportSendResult = (_ error: Error?) -> ()
typealias TransportParserHandler<U: AnyObject> = (U) -> Event<NKParser>.EventHandler

protocol NKTransport: class {
    
    var name: String { get }
    
    func send(comand: NKRawComand, handler: TransportSendResult?)
    func add<U: AnyObject>(target: U, handler: @escaping TransportParserHandler<U>, for parser: NKParser.Type) -> EventDisposable
    
}
