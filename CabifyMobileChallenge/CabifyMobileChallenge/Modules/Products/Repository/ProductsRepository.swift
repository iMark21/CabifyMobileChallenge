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
}
