//
//  NKEffectSectionController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/06/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxRelay

class NKEffectSectionController: ListSectionController {
    
    private var disposeBag = DisposeBag()
    private var model: NKEffect?
        
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
        
        
        guard let model = model, let cell = collectionContext?.dequeueReusableCell(of: NKEffectCell.self, for: self, at: index) as? NKEffectCell else {
            fatalError("Error model is nil")
        }
        
        
        cell.model = model
        
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        
        guard let model = self.model else {
            return
        }
        
        if model.isSet {
            return
        }
        
        model.isLoading = true
        model.deviceModel?.modelUpdatedSubject.onNext(())
   
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? NKEffect else {
            fatalError("model must be a NKDeviceModel")
        }
        model = object
    }
    
    deinit {
        NKLog("[NKEffectSectionController] - deinit")
    }
}
