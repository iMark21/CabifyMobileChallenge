//
//  Calculator.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 19/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import Foundation

class Calculator {

    // MARK: Calculator engine
    func calculateTotal(purchase : [(product: Product, quantity: Int)]) -> Double {
        let total = calculateSubtotal(purchase: purchase) + calculateDiscounts(purchase: purchase)
        return total
    }

    func calculateSubtotal(purchase : [(product: Product, quantity: Int)]) -> Double {
        var subtotal = 0.0
        for tuple in purchase {
            let price = Double(tuple.product.price)
            let quantity = Double(tuple.quantity)
            subtotal += (price * quantity)
        }
        return subtotal
    }

    func calculateDiscounts(purchase : [(product: Product, quantity: Int)]) -> Double {
        var discount = 0.0

        for tuple in purchase {
            let price = Double(tuple.product.price)
            var quantity = tuple.quantity

            if let promotions = tuple.product.promotions {
                for promotion in promotions {
                    switch promotion.promotionCode {
                    case PromotionType.promotion2x1:
                        if quantity % 2 == 0 {
                            discount -= (Double(quantity/2) * price)
                        } else {
                            quantity -=  1
                            if quantity > 0 {
                                discount -= (Double(quantity/2)  * price)
                            }
                        }
                    case PromotionType.promotionQuantity:
                        if quantity > 2 {
                            discount -= Double(quantity)
                        }
                    default:
                        break
                    }
                }
            }
            
        }
        return discount
    }
}
