//
//  ProductsCellViewModel.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ProductCellViewModel {
    //input
    let code : String
    let name : String
    let price : String
    var quantity : Int
    
    //output
    var unitButtonTapped = PublishSubject<Int>()
    
    init(product: Product) {
        code = product.code
        name = product.name
        price = String(product.price)
        quantity = 0
    }
    
    func addProduct(){
        quantity+=1
        unitButtonTapped.onNext(quantity)
    }
    
    func deleteProduct(){
        if quantity > 0{
            quantity-=1
        }
        unitButtonTapped.onNext(quantity)
    }
}
