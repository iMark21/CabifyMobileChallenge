//
//  ProductsCoordinator.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import UIKit

class ProductsCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if let viewController = ProductsViewController.instantiate() {
            let apiClient = APIClient.init()
            let repository = ProductsRepository.init(apiClient: apiClient)
            let calculator = Calculator.init()
            let viewModel =  ProductsViewModel.init(repository: repository, calculator: calculator)
            viewController.viewModel = viewModel
            navigationController.pushViewController(viewController, animated: true)
        }
    }

}
