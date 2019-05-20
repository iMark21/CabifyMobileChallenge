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
    private let repository: ProductsRepository
    private let calculator: Calculator
    private let disposeBag = DisposeBag()
    private var viewModels: [ProductCellViewModel]

    //input
    init(repository: ProductsRepository, calculator: Calculator) {
        self.repository = repository
        self.calculator = calculator
        viewModels = [ProductCellViewModel]()
    }

    func requestData() {
        state.onNext(.loading)
        resetCalculate()
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

    //output
    var state = PublishSubject<ProductsViewState>()

    func getTotalString() -> String {
        let total = calculator.calculateTotal(purchase: buildTuplesForCalculator(viewModels: viewModels))
        return NSLocalizedString("_total_", comment: "") + ": " + String(format: "%.2f", total)
    }

    func getSubtotalString () -> String {
        return NSLocalizedString("_subtotal_", comment: "") +
            ": " +
            String(format: "%.2f",
                   calculator.calculateSubtotal(purchase: buildTuplesForCalculator(viewModels: viewModels)))
    }

    func getDiscountString() -> String {
        return NSLocalizedString("_discount_", comment: "") +
            ": " +
            String(format: "%.2f",
                   calculator.calculateDiscounts(purchase: buildTuplesForCalculator(viewModels: viewModels)))
    }

    // MARK: ViewModel comunicative methods

    func buildCellViewModels(data: Products) -> [ProductCellViewModel] {
        var viewModels = [ProductCellViewModel]()
        for product in data.products {
            viewModels.append(ProductCellViewModel.init(product: product))
        }
        return viewModels
    }

    func buildTuplesForCalculator (viewModels: [ProductCellViewModel]) -> [(product: Product, quantity: Int)] {
        var result = [(product: Product, quantity: Int)]()
        for rowViewModel in viewModels {
            let price = Double(rowViewModel.price)
            let tuple = (Product.init(code: rowViewModel.code,
                                      name: rowViewModel.name,
                                      price: (price ?? 0)),
                         rowViewModel.quantity)
            result.append(tuple)
        }
        return result
    }

    // MARK: Calculator engine

    func resetCalculate() {
        viewModels = [ProductCellViewModel]()
    }

    func resetQuantities() {
        for rowViewModel in viewModels {
            rowViewModel.quantity = 0
        }
        self.state.onNext(.loaded(viewModels))
    }
}
