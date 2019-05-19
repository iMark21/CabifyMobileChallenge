//
//  ProductsCoordinator.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum ProductsChildCoordinator {
    case result
}

class ProductsCoordinator: CoordinatorProtocol {
    
    internal var navigationController: UINavigationController
    var finishModule: PublishSubject<Bool>

    init(navigationController: UINavigationController) {
        finishModule = PublishSubject<Bool>()
        self.navigationController = navigationController
    }
    
    func start() {
        if let viewController = ProductsViewController.instantiate(){
            let repository = ProductsRepository.init()
            let calculator = Calculator.init()
            let viewModel =  ProductsViewModel.init(repository: repository, calculator: calculator)
            viewController.viewModel = viewModel
            navigationController.pushViewController(viewController, animated: true)
        }
    }

}
