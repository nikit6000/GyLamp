//
//  UIViewController+extension.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 10/12/2019.
//  Copyright © 2019 nproject. All rights reserved.
//

import UIKit

extension UIViewController {

    var isModal: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
