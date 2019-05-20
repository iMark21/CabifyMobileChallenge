//
//  File.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 19/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductsRepository {
    func fetchProducts() -> Observable<Products> {
        return APIClient().send(apiRequest: ProductsRequest.init())
    }
    func fetchPromotions()  -> Observable<[Promotion]> {
        //This content will be provider from server

        let promotionMarketing = Promotion.init(promotionCode: PromotionType.promotion2x1,
                                                productCodeApply: AppConstants.Products.voucherCode)
        let promotionQuantity = Promotion.init(promotionCode: PromotionType.promotionQuantity,
                                               productCodeApply: AppConstants.Products.tshirtCode)
        return Observable.just([promotionMarketing, promotionQuantity])
    }
}
