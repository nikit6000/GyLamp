//
//  NKAdsSectionController.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 12.05.2020.
//  Copyright © 2020 nproject. All rights reserved.
//

import IGListKit
import GoogleMobileAds

class NKAdsSectionController: ListSectionController {
    
    private var model: NKNativeAdModel?
    private var loader: GADAdLoader?
    private var nativeAd: GADNativeAd?
    private var isLoading: Bool = false
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        
        return CGSize(width: containerSize.width - 16, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: NKNativeAdCell.self, for: self, at: index) as? NKNativeAdCell else {
            fatalError("cell must be a NKNativeAdCell")
        }
        
        cell.nativeAd = self.nativeAd
        
        return cell
    }
    
    override func numberOfItems() -> Int {
        
        if model == nil || nativeAd == nil {
            return 0
        }
        
        return 1
    }
    
    override func didUpdate(to object: Any) {
        
        guard let model = object as? NKNativeAdModel else {
            return
        }
        
        self.model = model
        
        loader = GADAdLoader(adUnitID: model.id,
                             rootViewController: self.viewController,
                             adTypes: [model.type],
                             options: model.options)
        
        loader!.delegate = self
        
        if (isLoading == false) {
            isLoading = true
            loader!.load(GADRequest())
        }
        
    }
    
}

extension NKAdsSectionController: GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        
        self.collectionContext?.performBatch(animated: true, updates: { [weak self] updater in
            
            guard let strongSelf = self else {
                return
            }
            
            updater.reload(strongSelf)
            
        }, completion: nil)
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        self.nativeAd = nil
        
        self.collectionContext?.performBatch(animated: true, updates: { [weak self] updater in
            
            guard let strongSelf = self else {
                return
            }
            
            updater.reload(strongSelf)
            
        }, completion: nil)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        isLoading = false
    }
    
}

