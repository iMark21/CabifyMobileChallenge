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
        let voucherProduct = (Product.init(code: AppConstants.Products.voucherCode,
                                           name: "Voucher",
                                           price: 5.0,
                                           promotions: []))
        let tshirtProduct = (Product.init(code: AppConstants.Products.tshirtCode,
                                          name: "Tshirt",
                                          price: 20.0,
                                          promotions: []))
        let mugProduct = (Product.init(code: AppConstants.Products.mugCode,
                                       name: "Mug",
                                       price: 7.5,
                                       promotions: []))

        let products = Products.init(products: [voucherProduct,
                                                tshirtProduct,
                                                mugProduct])
        return .just(products)
    }
    
    override func fetchPromotions() -> Observable<[Promotion]> {
        let promotion2x1Voucher = Promotion.init(promotionCode: PromotionType.promotion2x1,
                                                 productCodeApply: AppConstants.Products.voucherCode)
        let promotionQuantityTshirt = Promotion.init(promotionCode: PromotionType.promotionQuantity,
                                                     productCodeApply: AppConstants.Products.tshirtCode)
        
        let promotions = [promotion2x1Voucher, promotionQuantityTshirt]
        return .just(promotions)
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
