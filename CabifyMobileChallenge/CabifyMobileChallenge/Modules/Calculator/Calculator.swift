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

            //Voucher discounts
            if tuple.product.code == "VOUCHER" {
                if quantity % 2 == 0 {
                    discount -= (Double(quantity/2) * price)
                } else {
                    quantity -=  1
                    if quantity > 0 {
                        discount -= (Double(quantity/2)  * price)
                    }
                }
            }

            //Tshirt discounts
            if tuple.product.code == "TSHIRT" {
                if quantity > 2 {
                    discount -= Double(quantity)
                }
            }
        }
        return discount
    }
}
