//
//  NKGyverLampBetaSettingsInteractor.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 06.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

import Foundation
import CoreStore
import IGListKit
import Material

class NKGyverLampBetaSettingsInteractor: NKGyverLampBetaSettingsInteractorInputProtocolWithDelegate {
    
    var presenter: NKGyverLampBetaSettingsInteractorOutputProtocol?
    
    typealias SectionMap = [PartialKeyPath<GLSettingsModel>]
    
    private var settingsModelRef: GLSettingsModel? = nil
    private var tableData: [ListDiffable] = []
    private var sectionMappers: [SectionMap] = []
    
    weak var transport: NKTransport? = nil
    
    var key: String?
    var channel: UInt?
    
    func loadData() {
        
        if sectionMappers.isEmpty {
            
            let generalSectionMapper: SectionMap = [
                \GLSettingsModel.timeZone,
                \GLSettingsModel.cityId,
                \GLSettingsModel.adcMode,
                \GLSettingsModel.workTimeSince,
                \GLSettingsModel.workTimeUntil
            ]
            
            let lampSettingsMapper: SectionMap = [
                \GLSettingsModel.lampType,
                \GLSettingsModel.maxCurrent,
                \GLSettingsModel.length,
                \GLSettingsModel.width
            ]
            
            let lightSettingsMapper: SectionMap = [
                \GLSettingsModel.brightness,
                \GLSettingsModel.minBrightness,
                \GLSettingsModel.maxBrigtness
            ]
            
            let modeSettingsMapper: SectionMap = [
                \GLSettingsModel.modeChange,
                \GLSettingsModel.random,
                \GLSettingsModel.changePeriod
            ]
            
            sectionMappers.append(generalSectionMapper)
            sectionMappers.append(lampSettingsMapper)
            sectionMappers.append(lightSettingsMapper)
            sectionMappers.append(modeSettingsMapper)
            
        }
        
        CoreStoreUtil.shared.createOrFetch(onSuccess: { [weak self] (objectReference: GLSettingsModel) in
            self?.settingsModelRef = objectReference
            self?.makeTable()
        }, onError: { [weak self] error in
            self?.presenter?.on(error: error)
        })
    }
    
    func makeTable() {
        
        tableData.removeAll()

        
        let general = NKEnumSectionModel(sectionTitle: "gyverLampBetaView.general".localized,
                                         titles: [
                                            "gyverLampBetaView.general.timeZone".localized,
                                            "gyverLampBetaView.general.cityId".localized,
                                            "gyverLampBetaView.general.adcMode".localized,
                                            "gyverLampBetaView.general.workSince".localized,
                                            "gyverLampBetaView.general.workUntil".localized
                                         ],
                                         items: [
                                            NKDiscreteRangedModel(value: settingsModelRef!.timeZone, from: -12, to: 12, step: 1, format: "GMT %+.2d"),
                                            NKListRangedModel(value: settingsModelRef!.cityId, maxValue: .max, minValue: 0, format: "City id%d"),
                                            settingsModelRef!.adcMode,
                                            NKDiscreteRangedModel(value: settingsModelRef!.workTimeSince, from: 0, to: 23, step: 1, format: "%.2d:00"),
                                            NKDiscreteRangedModel(value: settingsModelRef!.workTimeUntil, from: 0, to: 23, step: 1, format: "%.2d:00")
                                         ],
                                         icons: [
                                            UIImage(named: "timeZone"),
                                            UIImage(named: "NTP"),
                                            UIImage(named: "ADC"),
                                            UIImage(named: "workSince"),
                                            UIImage(named: "workUntil")
                                         ],
                                         descriptions: [
                                            "gyverLampBetaView.general.timeZone.description".localized,
                                            "gyverLampBetaView.general.ntpServer.description".localized,
                                            "gyverLampBetaView.general.adcMode.description".localized,
                                            "gyverLampBetaView.general.workSince.description".localized,
                                            "gyverLampBetaView.general.workUntil.description".localized
                                         ])
        
        let lampSettings = NKEnumSectionModel(sectionTitle: "gyverLampBetaView.lamp".localized, titles: [
                                                    "gyverLampBetaView.general.lampType".localized,
                                                    "gyverLampBetaView.general.maxCurrent".localized,
                                                    "gyverLampBetaView.changeMode.length".localized,
                                                    "gyverLampBetaView.changeMode.width".localized
                                                ], items: [
                                                    settingsModelRef!.lampType,
                                                    NKListRangedModel(value: settingsModelRef!.maxCurrent, maxValue: 3000, minValue: 0, format: "%d mA"),
                                                    NKListRangedModel(value: settingsModelRef!.length, maxValue: 65535, minValue: 0, format: "%d px"),
                                                    NKListRangedModel(value: settingsModelRef!.width, maxValue: 65535, minValue: 0, format: "%d px")
                                                ], icons: [
                                                    UIImage(named: "lampType"),
                                                    UIImage(named: "maxCurrent"),
                                                    UIImage(named: "matrixLength"),
                                                    UIImage(named: "matrixWidth")
                                                ], descriptions: [
                                                    "gyverLampBetaView.general.lampType.description".localized,
                                                    "gyverLampBetaView.general.maxCurrent.description".localized,
                                                    "gyverLampBetaView.changeMode.length.description".localized,
                                                    "gyverLampBetaView.changeMode.width.description".localized
                                                ])
        
        let lightSettings = NKEnumSectionModel(sectionTitle: "gyverLampBetaView.brightness".localized,
                                               titles: [
                                                    "gyverLampBetaView.brightness.current".localized,
                                                    "gyverLampBetaView.brightness.min".localized,
                                                    "gyverLampBetaView.brightness.max".localized
                                               ],
                                               items: [
                                                    NKListRangedModel(value: settingsModelRef!.brightness, maxValue: 255, minValue: 0, format: "%.2f"),
                                                    NKListRangedModel(value: settingsModelRef!.minBrightness, maxValue: 255, minValue: 0, format: "%.2f"),
                                                    NKListRangedModel(value: settingsModelRef!.maxBrigtness, maxValue: 255, minValue: 0, format: "%.2f")
                                               ],
                                               icons: [
                                                    UIImage(named: "brightnessCurrent"),
                                                    UIImage(named: "brightnessMin"),
                                                    UIImage(named: "brightnessMax")
                                               ],
                                               descriptions: [
                                                    "gyverLampBetaView.brightness.current.description".localized,
                                                    "gyverLampBetaView.brightness.min.description".localized,
                                                    "gyverLampBetaView.brightness.max.description".localized
                                               ])
        
        let modeSettings = NKEnumSectionModel(sectionTitle: "gyverLampBetaView.presets".localized,
                                              titles: [
                                                    "gyverLampBetaView.changeMode".localized,
                                                    "gyverLampBetaView.randomMode".localized,
                                                    "gyverLampBetaView.changePeriod".localized
                                              ],
                                              items: [
                                                    settingsModelRef!.modeChange,
                                                    settingsModelRef!.random,
                                                    settingsModelRef!.changePeriod
                                              ],
                                              icons: [
                                                    UIImage(named: "changeMode"),
                                                    UIImage(named: "randomMode"),
                                                    UIImage(named: "changePeriod")
                                              ],
                                              descriptions: [
                                                    "gyverLampBetaView.changeMode.description".localized,
                                                    "gyverLampBetaView.randomMode.description".localized,
                                                    "gyverLampBetaView.changePeriod.description".localized
                                              ])
        
        
        tableData.append(general)
        tableData.append(lampSettings)
        tableData.append(lightSettings)
        tableData.append(modeSettings)
        
        presenter?.dataReady(data: tableData)
    }
    
    func packAndSend(model: GLSettingsModel) {
        
        guard let key = self.key, let channel = self.channel else {
            return
        }
        
        let packedConfig = model.packed
        let comand = GLSetCfg(config: packedConfig)
        let frame = GLComandFrame(channel: channel, key: key, payload: comand)
        
        transport?.send(comand: frame, handler: { [weak self] error in
            NKLog("NKGyverLampBetaSettingsInteractor", "Transport send completed, Error:", error == nil ? "nil" : error!)
            DispatchQueue.main.async {
                if error != nil {
                    self?.presenter?.on(error: error!)
                }
            }
        })
    }
    
    func updateModel(_ keyPath: String, value: Any) {
        
        guard let settingsModelRef = self.settingsModelRef else {
            return
        }

        CoreStoreUtil.shared.edit(field: keyPath, of: settingsModelRef, with: value, onSuccess: { [weak self] editedModelRef in
            self?.packAndSend(model: editedModelRef)
        }, onError: { [weak self] error in
            self?.presenter?.on(error: error)
        })
        
    }
    
    func sectionController(_ controller: ListSectionController, didUpdate value: Any, at index: Int) {
        guard controller.section < sectionMappers.count else {
            return
        }
        
        let sectionKeyPaths = sectionMappers[controller.section]
        
        guard index >= 1, index - 1 < sectionKeyPaths.count else {
            return
        }
        
        let keyPath = sectionKeyPaths[index - 1]
        
        NKLog("NKGyverLampBetaSettingsInteractor", "Updating parameter", "\"\(keyPath.stringValue)\"", "with new value:", value)
        
        updateModel(keyPath.stringValue, value: value)
    }
    
    deinit {
        NKLog("NKGyverLampBetaSettingsInteractor", "deinit")
    }
}
