//
//  NKLampSliderController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 26/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import IGListKit

class NKLampSliderController: ListSectionController {
    
    private var model: NKSliderModel? = nil
    
    public var isEnabled: Bool = true {
        didSet {
            
            collectionContext?.performBatch(animated: false, updates: { [weak self] updater in
                
                guard let controller = self else {
                    return
                }
                
                updater.reload(controller)
                
            }, completion: nil)
            
        }
    }
    
    override init() {
       
        super.init()
        
        isEnabled = self.section == 0
        
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 100, height: 280)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: NKVerticalSliderCell.self, for: self, at: index) as? NKVerticalSliderCell else {
            fatalError()
        }
        
        
        cell.model = model
        cell.slider.isEnabled = true
        cell.delegate = self
        
        return cell
        
    }
    
    override func didUpdate(to object: Any) {
        guard let model = object as? NKSliderModel else {
            return
        }
        
        self.model = model
    }
    
    deinit {
        NKLog("[NKLampSliderController] - deinit")
    }
    
}

extension NKLampSliderController: NKVerticalSliderCellDelegate {
    
    func verticalSliderCell(_ slider: NKVerticalSlider, changed value: CGFloat) {
        
        guard let model = self.model else {
            return
        }
        
        model.value = value
        
        model.model?.interpretatator.set(slider: model, onSuccess: {
            NKLog("[NKLampSliderController] success")
        }, onError: { error in
            
            guard let error = error as? NKUDPUtilError else {
                return
            }
            
            switch error {
                case .busy:
                    break
                default:
                    break
            }
            
        })
        //NKLog("[SECTION \(self.section)]:", value)
        
        
        
    }
    
}
