//
//  UIViewController+extensions.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 19/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        DispatchQueue.main.async {
            self.view.removeFromSuperview()
        }
    }
}
