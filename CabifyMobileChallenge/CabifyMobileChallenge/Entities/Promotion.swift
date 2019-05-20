//
//  Promotions.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marques Morilla on 20/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation

struct PromotionType {
    static let noPromotion = 0
    static let promotionQuantity = 1
    static let promotion2x1 = 2
}

struct Promotion: Codable {
    let promotionCode: Int
    let productCodeApply: String

    private enum Codingkeys: Int, CodingKey {
        case promotionCode
        case productCodeApply
    }
}
