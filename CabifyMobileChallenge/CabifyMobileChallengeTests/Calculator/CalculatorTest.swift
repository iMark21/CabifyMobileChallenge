//
//  CabifyMobileChallengeTests.swift
//  CabifyMobileChallengeTests
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import XCTest

@testable import CabifyMobileChallenge

class CalculatorTest: XCTestCase {

    private var calculator: Calculator!
    private var voucherProduct: Product!
    private var tshirtProduct: Product!
    private var mugProduct: Product!

    override func setUp() {
        calculator = Calculator()

        let promotion2x1Voucher = Promotion.init(promotionCode: PromotionType.promotion2x1,
                                                 productCodeApply: AppConstants.Products.voucherCode)
        
        let promotionQuantityTshirt = Promotion.init(promotionCode: PromotionType.promotionQuantity,
                                                     productCodeApply: AppConstants.Products.tshirtCode)

        voucherProduct = (Product.init(code: AppConstants.Products.voucherCode,
                                       name: "Voucher",
                                       price: 5.0,
                                       promotions: [promotion2x1Voucher]))
        tshirtProduct = (Product.init(code: AppConstants.Products.tshirtCode,
                                      name: "Tshirt",
                                      price: 20.0,
                                      promotions: [promotionQuantityTshirt]))
        mugProduct = (Product.init(code: AppConstants.Products.mugCode,
                                   name: "Mug",
                                   price: 7.5,
                                   promotions: []))
    }

    override func tearDown() {
        calculator = nil

        super.tearDown()
    }

    func testCalculatorlInit() {
        XCTAssertNotNil(calculator)
    }

    func testNoBuyProducts() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: tshirtProduct, quantity: 0))
        tuples.append((product: voucherProduct, quantity: 0))
        tuples.append((product: mugProduct, quantity: 0))
        let total = calculator.calculateTotal(purchase: tuples)
        XCTAssertTrue(total == 0)
    }

    func testBuy1voucher1tshirt1mug() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: tshirtProduct, quantity: 1))
        tuples.append((product: voucherProduct, quantity: 1))
        tuples.append((product: mugProduct, quantity: 1))
        let total = calculator.calculateTotal(purchase: tuples)
        XCTAssertTrue(total == 32.50)
    }

    func testBuy3voucher3tshirt1mug() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: tshirtProduct, quantity: 3))
        tuples.append((product: voucherProduct, quantity: 3))
        tuples.append((product: mugProduct, quantity: 1))
        let total = calculator.calculateTotal(purchase: tuples)
        XCTAssertTrue(total == 74.50)
    }

    func testDiscount3Voucher() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: voucherProduct, quantity: 3))
        let discountApplied = calculator.calculateDiscounts(purchase: tuples)
        XCTAssertTrue(discountApplied == -5.0)
    }

    func testDiscount6Voucher() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: voucherProduct, quantity: 6))
        let discountApplied = calculator.calculateDiscounts(purchase: tuples)
        XCTAssertTrue(discountApplied == -15.0)
    }

    func testDiscount3Tshirt() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: tshirtProduct, quantity: 3))
        let discountApplied = calculator.calculateDiscounts(purchase: tuples)
        XCTAssertTrue(discountApplied == -3.0)
    }

    func testDiscount3Tshirt3Voucher() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: tshirtProduct, quantity: 3))
        tuples.append((product: voucherProduct, quantity: 3))
        let discountApplied = calculator.calculateDiscounts(purchase: tuples)
        XCTAssertTrue(discountApplied == -8.0)
    }

    func testNoDiscountMugQuantity() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: mugProduct, quantity: 30))
        let discountApplied = calculator.calculateDiscounts(purchase: tuples)
        XCTAssertTrue(discountApplied == 0)
    }

    func testNoDiscountMug2x1() {
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: mugProduct, quantity: 2))
        let discountApplied = calculator.calculateDiscounts(purchase: tuples)
        XCTAssertTrue(discountApplied == 0)

        let total = calculator.calculateTotal(purchase: tuples)
        XCTAssertTrue(total == mugProduct.price * 2)
    }

}
