//
//  NKDeviceInterpretator.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 16/01/2020.
//  Copyright © 2020 nproject. All rights reserved.
//

/*import Foundation
import RxSwift
import RxRelay

typealias NKDeviceInterpretatorSuccessBlock = () -> ()
typealias NKDeviceAnswerSuccessBlock = (_ answer: String) -> ()
typealias NKDeviceInterpretatorErrorBlock = (_ error: Error) -> ()

enum NKDeviceState: Int {
    case off
    case on
    case unknown
}

class NKDeviceInterpretator: NSObject {
    
    
    private var connection: UDPClient?
    private var address: String
    private var port: Int32
    
    private var disposeBag = DisposeBag()
    
    private let deviceQueue = DispatchQueue(label: "pw.nproject.gylamp.deviceInt")
    private let deviceQueueRx = DispatchQueue(label: "pw.nproject.gylamp.deviceIntRx")
    
    private(set) var isBusy: Bool = false
    
    public weak var model: NKDeviceProtocol?
    
    init(address: String, port: Int32) {
        self.address = address
        self.port = port
        super.init()
        setupObservers()
    }
    
    private func setupObservers() {
        
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .subscribe(onNext: { [weak self] _ in
                self?.connect(onSuccess: nil, onError: nil)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .subscribe(onNext: { [weak self] _ in
                self?.disconnect(onDone: nil)
            })
            .disposed(by: disposeBag)
    }
    
    public func connect(onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        
        deviceQueue.async { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.connection = UDPClient(address: strongSelf.address, port: strongSelf.port)
            
            if strongSelf.connection!.address != strongSelf.address {
                errorBlock?(NKUDPUtilError.noConnection)
                return
            }
            
            strongSelf.connection!.enableTimeout(sec: 1, usec: 0)
            successBlock?()
            
            NKLog("[Interpratator] - device connected")
        }
        
    }
    
    public func disconnect(onDone doneBlock: NKDeviceInterpretatorSuccessBlock?) {
        
        deviceQueue.async { [weak self] in
            self?.connection?.close()
            self?.connection = nil
            
            doneBlock?()
            
            NKLog("[Interpratator] - device disconnected")
        }
        
    }
    
    public func set(state: NKDeviceState, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        fatalError("Calling an abstract function")
    }
    
    public func set(mode: Int, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        fatalError("Calling an abstract function")
    }
    
    public func set(slider model: NKSliderModel, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        
        let fullCmd = model.cmd + model.strVal
        
        send(cmd: fullCmd, onSuccess: successBlock, onError: errorBlock)
        
    }
    
    public func set(alarmTime model: NKAlarmModel, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        
        let fullCmd = model.setCmd + "\(model.absMins())"
        send(cmd: fullCmd, onSuccess: successBlock, onError: errorBlock)
    }
    
    public func set(alarmState model: NKAlarmModel, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        
        let state = (model.isOn == true) ? "ON" : "OFF"
        let fullCmd = model.setCmd + state
        send(cmd: fullCmd, onSuccess: successBlock, onError: errorBlock)
    }
    
    public func set(alarmDawn model: NKAlarmModel, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {

        let fullCmd = model.dawnCmd
        send(cmd: fullCmd, onSuccess: successBlock, onError: errorBlock)
    }
    
    public func process(answer: String) {
        fatalError("Calling an abstract function")
    }
    
    private func recevice(retry: Int) -> String? {
                
        guard let connection = self.connection else {
            return nil
        }
        
        let answer = connection.recv(2048)
        
        NKLog("[Interpretator] result:", answer)
        
        guard let data = answer.0, let answerStr = String(bytes: data, encoding: .utf8) else {
            
            if (retry == 0) {
                return nil
            }
            
            return self.recevice(retry: retry - 1)
        }
        
        return answerStr
    }
    
    private func receive(onSuccess successBlock: NKDeviceAnswerSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        
        deviceQueueRx.async { [weak self] in
            
            let answer = self?.recevice(retry: 5)
            
            if answer == nil {
                errorBlock?(NKUDPUtilError.noDataReaded)
            } else {
                successBlock?(answer!)
            }
            
            
        }
        
    }
    
    public func send(cmd: String, onSuccess successBlock: NKDeviceInterpretatorSuccessBlock?, onError errorBlock: NKDeviceInterpretatorErrorBlock?) {
        
        if (isBusy) {
            errorBlock?(NKUDPUtilError.busy)
            //NKLog("[Interpretator] - busy")
            return
        }
        
        NKLog("[Interpretator] cmd:", cmd)
        
        deviceQueue.async { [weak self] in
            
            guard let connection = self?.connection else {
                self?.isBusy = false
                errorBlock?(NKUDPUtilError.noConnection)
                return
            }
            
            self?.isBusy = true
            
            self?.receive(onSuccess: { answer in
                
                self?.process(answer: answer)
                
            }, onError: errorBlock)
            
            let result = connection.send(string: cmd)
            
            switch (result) {
                case .failure(_):
                    self?.isBusy = false
                    errorBlock?(NKUDPUtilError.noConnection)
                    return
                default:
                    break
            }
            
            self?.isBusy = false
            successBlock?()
            
        }
        
    }
    
    
    
    
    
}
*/
