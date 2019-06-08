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

protocol ProductsViewModelProtocol {
    var repository: ProductsRepository { get }
    var calculator: Calculator { get }
    
    var state : PublishSubject<ProductsViewState> { get }
    
    func requestData()
    func getTotalString() -> String
    func getSubtotalString() -> String
    func getDiscountString() -> String
}

class ProductsViewModel : ProductsViewModelProtocol {
    
    var repository: ProductsRepository
    var calculator: Calculator
    
    let disposeBag = DisposeBag()
    private var productCellViewModel: [ProductCellViewModel]
    private var promotions: [Promotion]
    
    // MARK: Input
    
    init(repository: ProductsRepository, calculator: Calculator) {
        self.repository = repository
        self.calculator = calculator
        productCellViewModel = [ProductCellViewModel]()
        promotions = [Promotion]()
    }
    
    func requestData() {
        state.onNext(.loading)
        resetCalculate()
        repository.fetchProducts()
            .observeOn(MainScheduler.instance)
            .flatMap({ (products) -> Observable<[ProductCellViewModel]> in
                return self.buildCellViewModels(data: products)
            }).subscribe(onNext: { (cellViewModels) in
                self.productCellViewModel = cellViewModels
            }, onError: { (error) in
                self.state.onNext(.error)
            }, onCompleted: {
                self.repository.fetchPromotions()
                    .flatMap({ (promotions) -> Observable<[Promotion]> in
                        self.promotions = promotions
                        return Observable.just(promotions)
                    }).subscribe(onNext: { (_) in
                        self.state.onNext(.loaded(self.productCellViewModel))
                    }, onError: { (error) in
                        self.state.onNext(.error)
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Output
    
    var state = PublishSubject<ProductsViewState>()
    
    func getTotalString() -> String {
        let total = calculator.calculateTotal(purchase: buildTuplesForCalculator(viewModels: productCellViewModel))
        return NSLocalizedString("_total_", comment: "") + ": " + String(format: "%.2f", total)
    }
    
    func getSubtotalString () -> String {
        return NSLocalizedString("_subtotal_", comment: "") +
            ": " +
            String(format: "%.2f",
                   calculator.calculateSubtotal(purchase: buildTuplesForCalculator(viewModels: productCellViewModel)))
    }
    
    func getDiscountString() -> String {
        return NSLocalizedString("_discount_", comment: "") +
            ": " +
            String(format: "%.2f",
                   calculator.calculateDiscounts(purchase: buildTuplesForCalculator(viewModels: productCellViewModel)))
    }
    
    // MARK: ViewModel Map Methods
    
    private func buildCellViewModels(data: Products) -> Observable <[ProductCellViewModel]> {
        var viewModels = [ProductCellViewModel]()
        for product in data.products {
            viewModels.append(ProductCellViewModel.init(product: product))
        }
        return Observable.just(viewModels)
    }
    
    private func buildTuplesForCalculator (viewModels: [ProductCellViewModel]) -> [(product: Product, quantity: Int)] {
        var result = [(product: Product, quantity: Int)]()
        for rowViewModel in viewModels {
            let price = Double(rowViewModel.price)
            let promotionsToApply = getPromotions(promotions: promotions, rowViewModel: rowViewModel)
            let tuple = (Product.init(code: rowViewModel.code,
                                      name: rowViewModel.name,
                                      price: (price ?? 0),
                                      promotions: promotionsToApply), rowViewModel.quantity)
            result.append(tuple)
        }
        return result
    }
    
    private func getPromotions(promotions: [Promotion], rowViewModel: ProductCellViewModel) -> [Promotion] {
        return promotions.filter { $0.productCodeApply.elementsEqual(rowViewModel.code) }
    }
    
    // MARK: Calculator engine
    
    func resetCalculate() {
        productCellViewModel = [ProductCellViewModel]()
    }
    
    func resetQuantities() {
        for rowViewModel in productCellViewModel {
            rowViewModel.quantity = 0
        }
        self.state.onNext(.loaded(productCellViewModel))
    }
}
