//
//  UDPTransport.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 02.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

typealias UDPTransportConnectionResult = (_ error: Error?) -> ()

enum UDPTransportError: Error {
    case noConnection
    case noDataToSend
}

class UDPTransport: NSObject, NKTransport {
    
    private var socket: GCDAsyncUdpSocket
    
    private let txQueue = DispatchQueue(label: "pw.nproject.gylamp.UDPTransport.tx")
    private let rxQueue = DispatchQueue(label: "pw.nproject.gylamp.UDPTransport.rx")
    
    private var disconnectHandler: UDPTransportConnectionResult?
    private var connectionHandler: UDPTransportConnectionResult?
    private var sendHandlers: [Int: TransportSendResult]
    
    private var receiveHandlers: [HashableType<NKParser>: Event<NKParser>]
    
    private var sendSeqNumber: Int = 0
    
    public var isBroadcastEnabled: Bool {
        didSet {
            do {
                try socket.enableBroadcast(isBroadcastEnabled)
            } catch (_) { }
        }
    }
    
    
    var name: String {
        return "UDP"
    }
    
    init(broadcast: Bool = false) {
        socket = GCDAsyncUdpSocket(socketQueue: txQueue)
        isBroadcastEnabled = broadcast
        sendHandlers = [:]
        receiveHandlers = [:]
        super.init()
        
        socket.setDelegate(self)
        socket.setDelegateQueue(.main)
    }
    
    func connect(to address: String, port: UInt16, handler: UDPTransportConnectionResult? = nil) {
        
        do {
            try socket.connect(toHost: address, onPort: port)
            connectionHandler = handler
        } catch ( let error ) {
            handler?(error)
        }
        
    }
    
    func disconnect(handler: UDPTransportConnectionResult? = nil) {
        socket.close()
        disconnectHandler = handler
    }
    
    func send(comand: NKRawComand, handler: TransportSendResult? = nil) {
        
        guard let adress = socket.connectedAddress(), let data = comand.data else {
            if (comand.data == nil) {
                handler?(UDPTransportError.noDataToSend)
            } else {
                handler?(UDPTransportError.noConnection)
            }
            return
        }
        
        socket.send(data, toAddress: adress, withTimeout: 5, tag: sendSeqNumber)
        
        if handler != nil {
            sendHandlers[sendSeqNumber] = handler!
        }
        
        sendSeqNumber += 1
    }
    
    func add<U: AnyObject>(target: U, handler: @escaping TransportParserHandler<U>, for parser: NKParser.Type) -> EventDisposable {
        
        if receiveHandlers[parser] == nil {
            receiveHandlers[parser] = Event<NKParser>()
        }
        
        return receiveHandlers[parser]!.addHandler(target: target, handler: handler)
    }
    
}

extension UDPTransport: GCDAsyncUdpSocketDelegate {
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        if connectionHandler != nil {
            connectionHandler!(error)
        }
        NKLog("UDPTransport.didNotConnect")
    }
    
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        if disconnectHandler != nil {
            disconnectHandler!(error)
        }
        NKLog("UDPTransport.udpSocketDidClose")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        if let handler = sendHandlers[tag] {
            handler(nil)
            sendHandlers[tag] = nil
        }
        NKLog("UDPTransport.didSendDataWithTag", "Tag:", tag)
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        if connectionHandler != nil {
            connectionHandler!(nil)
        }
        NKLog("UDPTransport.didConnectToAddress", sock.connectedHost() ?? "N/A")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        NKLog("UDPTransport.didReceive", String(bytes: data, encoding: .utf8) ?? "N/A")
    }
    
}
