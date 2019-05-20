//
//  MockRepository.swift
//  CabifyMobileChallengeTests
//
//  Created by Juan Miguel Marques Morilla on 20/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import CabifyMobileChallenge

class MockRepository: ProductsRepository {

    override func fetchProducts() -> Observable<Products> {

        let voucherProduct = Product.init(code: "VOUCHER",
                                          name: "Cabify Voucher",
                                          price: 5.0)
        let tshirtProduct = Product.init(code: "TSHIRT",
                                         name: "Cabify T-Shirt",
                                         price: 20.0)
        let mugProduct = Product.init(code: "MUG",
                                      name: "Cabify Coffee Mug",
                                      price: 7.5)

        let products = Products.init(products: [voucherProduct,
                                                tshirtProduct,
                                                mugProduct])

        return .just(products)
    }

}

class RxCollector<T> {
    var disposeBag = DisposeBag()
    var toArray: [T] = [T]()
    func collect(from observable: Observable<T>) -> RxCollector {
        observable.asObservable()
            .subscribe(onNext: { (newZombie) in
                self.toArray.append(newZombie)
            }).disposed(by: disposeBag)
        return self
    }
}
