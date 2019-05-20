//
//  AppCoordinator.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum AppChildCoordinator {
    case productList
}

class AppCoordinator: CoordinatorProtocol {
    
    internal var navigationController: UINavigationController
    
    private let window: UIWindow
    private var childCoordinators = [AppChildCoordinator: CoordinatorProtocol]()
    let disposeBag = DisposeBag()

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        self.window.rootViewController = navigationController
    }
    
    func start() {
        startProductModule()
    }
    
    func startProductModule() {
        let coordinator = ProductsCoordinator(navigationController: navigationController)
        childCoordinators[.productList] = coordinator
        coordinator.start()
    }

}
