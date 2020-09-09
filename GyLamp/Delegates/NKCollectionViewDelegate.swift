//
//  NKCollectionViewDelegate.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05/10/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

@objc protocol NKCollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, didSelectExtendedItemAt indexPath: IndexPath)
}
