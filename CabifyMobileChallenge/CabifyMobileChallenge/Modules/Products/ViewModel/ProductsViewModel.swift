//
//  ProductsViewModel.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ProductsViewState {
    case loading
    case empty
    case error
    case loaded ([ProductCellViewModel])
}

class ProductsViewModel {
    private let repository : ProductsRepository
    private let disposeBag = DisposeBag()
    private var viewModels = [ProductCellViewModel]()
    
    //output
    var state = PublishSubject<ProductsViewState>()
    
    init(repository : ProductsRepository) {
        self.repository = repository
    }
    
    func requestData(){
        state.onNext(.loading)
        repository.fetchProducts()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (products : Products) in
                self.viewModels = self.buildCellViewModels(data: products)
            }, onError: { (error) in
                self.state.onNext(.error)
            }, onCompleted: {
                self.state.onNext(.loaded(self.viewModels))
            }).disposed(by: disposeBag)
    }
    
    func buildCellViewModels(data: Products) -> [ProductCellViewModel] {
        var viewModels = [ProductCellViewModel]()
        for product in data.products {
            viewModels.append(ProductCellViewModel.init(product: product))
        }
        return viewModels
    }
}
