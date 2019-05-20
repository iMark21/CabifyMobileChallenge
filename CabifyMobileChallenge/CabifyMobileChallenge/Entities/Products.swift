//
//  Product.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation

struct Products: Codable {
    let products: [Product]

    private enum Codingkeys: String, CodingKey {
        case products
    }
}

struct Product: Codable {
    let code: String
    let name: String
    let price: Double
    let promotions: [Promotion]?

    private enum Codingkeys: String, CodingKey {
        case code
        case name
        case price
        case promotions
    }
}
