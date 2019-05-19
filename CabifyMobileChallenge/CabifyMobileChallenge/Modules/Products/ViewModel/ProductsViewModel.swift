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
    var viewModels : [ProductCellViewModel]
    
    //output
    var state = PublishSubject<ProductsViewState>()
    var totalString : String
    var subtotalString : String
    var discountString : String
    
    
    init(repository : ProductsRepository) {
        self.repository = repository
        viewModels = [ProductCellViewModel]()
        totalString = "\(0)"
        subtotalString = "\(0)"
        discountString = "\(0)"
    }
    
    func requestData(){
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
    
    func buildCellViewModels(data: Products) -> [ProductCellViewModel] {
        var viewModels = [ProductCellViewModel]()
        for product in data.products {
            viewModels.append(ProductCellViewModel.init(product: product))
        }
        return viewModels
    }
    
    // MARK: Calculator engine

    func calculateTotal(){
        let total = calculateSubtotal() + calculateDiscounts()
        totalString = NSLocalizedString("_total_", comment: "") + ": " + String(format: "%.2f", total)
    }
    
    private func calculateSubtotal() -> Double{
        var subtotal = 0.0
        for rowViewModel in viewModels {
            let price = Double(rowViewModel.price)
            let quantity = Double(rowViewModel.quantity)
            subtotal = subtotal + ((price ?? 0) * quantity)
        }
        subtotalString = NSLocalizedString("_subtotal_", comment: "") + ": " + String(format: "%.2f", subtotal)
        return subtotal
    }
    
    private func calculateDiscounts() -> Double{
        var discount = 0.0
        //Tshirt discounts
        if let tshirtRowViewModel = viewModels.filter({ $0.code == "TSHIRT" }).first {
            if tshirtRowViewModel.quantity > 2 {
                discount = Double(-tshirtRowViewModel.quantity)
            }
        }
        //Voucher discounts
        if let voucherRowViewModel = viewModels.filter({ $0.code == "VOUCHER" }).first {
            let price = Double(voucherRowViewModel.price)
            var quantity = Double(voucherRowViewModel.quantity)
            if voucherRowViewModel.quantity % 2 == 0 {
                discount = discount - (quantity/2 * (price ?? 0))
            }else{
                quantity = quantity - 1
                if quantity > 0 {
                    discount = discount - (quantity/2 * (price ?? 0))
                }
            }
        }
        discountString = NSLocalizedString("_discount_", comment: "") + ": " + String(format: "%.2f", discount)
        return discount
    }
    
    func resetCalculate(){
        viewModels = [ProductCellViewModel]()
        calculateTotal()
    }
    
    func resetQuantities(){
        for rowViewModel in viewModels {
            rowViewModel.quantity = 0
        }
        self.state.onNext(.loaded(viewModels))
    }
}

