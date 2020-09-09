//
//  NKAlarmSectionController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 28/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxRelay

class NKAlarmSectionController: ListSectionController {
    
    private var model: NKAlarmModel?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let size = collectionContext?.containerSize else {
            return CGSize(width: 112, height: 112)
        }
        
        let onScreenCount: CGFloat = 3.3
        
        return CGSize(width: size.width / onScreenCount - 8.0, height: size.width / onScreenCount - 8.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKAlarmCell.self, for: self, at: index) as? NKAlarmCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.model = model
        
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
        guard let model = self.model else {
            return
        }
        
        model.isOn = !model.isOn
        model.deviceModel?.interpretatator.set(alarmState: model, onSuccess: nil, onError: { _ in
            model.hasError = true
            model.isLoading = false
            model.deviceModel?.modelUpdatedSubject.onNext(())
        })
        model.isOn = !model.isOn
        model.isLoading = true
        model.deviceModel?.modelUpdatedSubject.onNext(())
        
    }
    
    override func didLongPress(item: Int) {
        
        guard let model = self.model else {
            return
        }
        
        guard let cell = collectionContext?.cellForItem(at: item, sectionController: self) else {
            return
        }
        
        
        let actionView = NKActionView()
        let timePicker = NKTimeEdit(frame: CGRect(x: 0, y: 0, width: 512, height: 512))
        
        let title: String = NSLocalizedString("alarm.dawnMode", comment: "")
  
        
        timePicker.date = model.date
        
        timePicker.onChange { date in
            model.date = date
            model.deviceModel?.modelUpdatedSubject.onNext(())
            model.deviceModel?.interpretatator.set(alarmTime: model, onSuccess: nil, onError: nil)
            actionView.drawSnapshot()
        }
        
        actionView.addAction(title, style: .default) { button in
            
            model.dawnMode += 1
            
            model.deviceModel?.interpretatator.set(alarmDawn: model, onSuccess: nil, onError: nil)
            model.deviceModel?.modelUpdatedSubject.onNext(())
            
        }
        
        actionView.addExtra(view: timePicker)
        
        actionView.present(for: cell.contentView)
        
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? NKAlarmModel else {
            fatalError("model must be a NKDeviceModel")
        }
        model = object
    }

    deinit {
        NKLog("[NKAlarmController] - deinit")
    }
    
}

