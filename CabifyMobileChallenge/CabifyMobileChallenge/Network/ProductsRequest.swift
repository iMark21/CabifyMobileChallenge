//
//  ProductsRequest.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation

class ProductsRequest: APIRequest {
    var method:  RequestType
    var endPoint: String

    init(method: RequestType){
        self.method = method
        self.endPoint = NetworkConstants.EndPoint.products
    }
}
