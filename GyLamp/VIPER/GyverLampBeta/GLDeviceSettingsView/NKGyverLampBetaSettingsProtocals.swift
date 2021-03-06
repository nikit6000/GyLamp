//
//  NKGyverLampBetaSettingsSettingsProtocals.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//
import Foundation
import IGListKit

protocol NKGyverLampBetaSettingsRouterProtocol: class {
    
    static func createViewModule(ref: NKGyverLampBetaSettingsView)
    
}

protocol NKGyverLampBetaSettingsProtocol: class {
    
    func show(data: [ListDiffable], animated: Bool)
    func show(error: Error)
    
}

typealias NKGyverLampBetaSettingsInteractorInputProtocolWithDelegate = NKGyverLampBetaSettingsInteractorInputProtocol & NKSectionDataChangedDelegate

protocol NKGyverLampBetaSettingsPresenterProtocol: class {
    
    var interactor: NKGyverLampBetaSettingsInteractorInputProtocolWithDelegate? {get set}
    var view: NKGyverLampBetaSettingsProtocol? {get set}
    var router: NKGyverLampBetaSettingsRouterProtocol? {get set}
    
    func viewDidLoad()
}

protocol NKGyverLampBetaSettingsInteractorInputProtocol: class {
    var presenter: NKGyverLampBetaSettingsInteractorOutputProtocol? {get set}
    
    var transport: NKTransport? { get set }
    var key: String? { get set }
    var channel: UInt? { get set }
    
    func loadData()
    func makeTable()
    
}

protocol NKGyverLampBetaSettingsInteractorOutputProtocol: class {
    
    func dataReady(data: [ListDiffable])
    func on(error: Error)
    
}
