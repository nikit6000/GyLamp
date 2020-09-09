//
//  NKDeviceController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift

@available(*, deprecated, message: "outdated")
protocol NKSectionControllerDelegate: class {
    func didSelect(controller: ListSectionController, in section: Int, at index: Int)
}


class NKDeviceController: ListSectionController {
    
    private(set) var model: NKDeviceModel!
    private var disposeBag = DisposeBag()
    
    @available(*, deprecated, message: "Outdate")
    public weak var delegate: NKSectionControllerDelegate? = nil
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let size = collectionContext?.containerSize else {
            return CGSize(width: 112, height: 112)
        }
        
        let onScreenCount: CGFloat = 3.0
        
        return CGSize(width: size.width / onScreenCount - 8.0, height: size.width / onScreenCount - 8.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKDeviceCell.self, for: self, at: index) as? NKDeviceCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.model = model
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? NKDeviceModel else {
            fatalError("model must be a NKDeviceModel")
        }
        model = object
    }
    
    override func didSelectItem(at index: Int) {
        guard let viewController = viewController as? NKScanDeviceView else {
            return
        }
        
        viewController.presenter?.router?.pushView(device: model)
    }
    
    
    override func didLongPress(item: Int) {
        
        guard let cell = collectionContext?.cellForItem(at: item, sectionController: self) else {
            return
        }
        
        let actionView = NKActionView()
        
        
        if model.managedObject != nil {
            actionView.addAction(NSLocalizedString("device.delete", comment: ""), style: .danger) { [weak self] _ in
                
                guard let strongSelf = self else {
                    return
                }
                
                let worker = NKCoreDataWorker.shared
                
                worker.rx.delete(model: strongSelf.model)
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onError: { _ in
                        actionView.dismiss()
                    }, onCompleted: {
                        actionView.dismiss(hideSnapshot: true)
                        
                    })
                    .disposed(by: strongSelf.disposeBag)
                
            }
        } else {
            actionView.addAction(NSLocalizedString("device.save", comment: ""), style: .default) { [weak self] _ in
                
                guard let strongSelf = self else {
                    return
                }
                
                let worker = NKCoreDataWorker.shared
                
                worker.rx.save(model: strongSelf.model)
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onError: { _ in
                        actionView.dismiss()
                    }, onCompleted: {
                        actionView.dismiss()
                    })
                    .disposed(by: strongSelf.disposeBag)
                
            }
        }
        
        //actionView.addAction("Cancel", style: .cancel)
        
        
        
        actionView.present(for: cell.contentView)
    }
    
    deinit {
        NKLog("NKDeviceController - deinit")
    }
    
}

