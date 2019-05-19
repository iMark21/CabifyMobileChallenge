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
    
    //output
    var unitButtonTapped = PublishSubject<Bool>()
    
    init(product: Product) {
        code = product.code
        name = product.name
        price = String(product.price)
    }
    
    func addProduct(){
        unitButtonTapped.onNext(true)
    }
    
    func deleteProduct(){
        unitButtonTapped.onNext(false)
    }
}
