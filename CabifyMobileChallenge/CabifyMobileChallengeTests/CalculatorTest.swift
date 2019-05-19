//
//  CabifyMobileChallengeTests.swift
//  CabifyMobileChallengeTests
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import XCTest
import RxBlocking
import RxCocoa
import RxSwift
import RxTest

@testable import CabifyMobileChallenge

class CalculatorTest: XCTestCase {
    
    private var calculator : Calculator!
    private var voucherProduct : Product!
    private var tshirtProduct : Product!
    private var mugProduct : Product!

    
    override func setUp() {
        calculator = Calculator()
        voucherProduct = (Product.init(code: "VOUCHER", name: "Voucher", price: 5.0))
        tshirtProduct = (Product.init(code: "TSHIRT", name: "Voucher", price: 20.0))
        mugProduct = (Product.init(code: "MUG", name: "Mug", price: 7.5))
    }
    
    override func tearDown() {
        calculator = nil
        
        super.tearDown()
    }
    
    func testBuy1voucher1tshirt1mug(){
        var tuples = [(product: Product, quantity: Int)]()
        tuples.append((product: tshirtProduct, quantity: 1))
        tuples.append((product: voucherProduct, quantity: 1))
        tuples.append((product: mugProduct, quantity: 1))
        let total = calculator.calculateTotal(purchase: tuples)
        XCTAssertTrue(total == 32.50)
    }
    
    func testBuy3voucher3tshirt1mug(){
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

    
}
