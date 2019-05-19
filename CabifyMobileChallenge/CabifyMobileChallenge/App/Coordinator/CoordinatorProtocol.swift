//
//  CoordinatorProtocol.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CoordinatorProtocol: class {
    var navigationController: UINavigationController { get set }
    
    func start()
}
