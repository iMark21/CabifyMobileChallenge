//
//  ProductsViewModelTest.swift
//  CabifyMobileChallengeTests
//
//  Created by Juan Miguel Marqués Morilla on 20/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import XCTest
import RxBlocking
import RxCocoa
import RxSwift
import RxTest

@testable import CabifyMobileChallenge

class ProductsViewModelTest: XCTestCase {

    private var viewModel: ProductsViewModel!
    private var products: Products!
    private var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        viewModel = ProductsViewModel.init(repository: MockRepository(), calculator: Calculator())

        let voucherProduct = Product.init(code: "VOUCHER",
                                          name: "Cabify Voucher",
                                          price: 5.0)
        let tshirtProduct = Product.init(code: "TSHIRT",
                                         name: "Cabify T-Shirt",
                                         price: 20.0)
        let mugProduct = Product.init(code: "MUG",
                                      name: "Cabify Coffee Mug",
                                      price: 7.5)

        products = Products.init(products: [voucherProduct, tshirtProduct, mugProduct])
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testViewModelInit() {
        XCTAssertNotNil(viewModel)
    }

    func testBuildProductCellViewModel() {
        //Given products build cellViewModels
        let viewCellModels = viewModel.buildCellViewModels(data: products)
        XCTAssertEqual(viewCellModels.count, products.products.count)

        //Then
        XCTAssertTrue(viewCellModels[0].code == products.products[0].code)
        XCTAssertTrue(viewCellModels[1].code == products.products[1].code)
        XCTAssertTrue(viewCellModels[2].code == products.products[2].code)
    }

    func testBuildTuples() {
        //Given products build tuples for calculator
        let viewCellModels = viewModel.buildCellViewModels(data: products)
        let tuples = viewModel.buildTuplesForCalculator(viewModels: viewCellModels)

        //Then compare if number of items is the same
        XCTAssertEqual(viewCellModels.count, tuples.count)
    }

    func testStateSubscribeOnNext() {
        let state = viewModel.state

        let collector = RxCollector<ProductsViewState>()
            .collect(from: state.asObservable())
        state.onNext((.loading))
        state.onNext((.loaded(viewModel.buildCellViewModels(data: products))))
        state.onNext((.error))
        state.onNext((.empty))

        XCTAssertEqual(collector.toArray.count, 4)
    }

    func testResetCalculate() {
        viewModel.resetCalculate()
        XCTAssertTrue(viewModel.getTotalString() == NSLocalizedString("_total_", comment: "") + ": " + "0.00")
    }

    func testResetQuantities() {
        viewModel.resetQuantities()
        XCTAssertTrue(viewModel.getTotalString() == NSLocalizedString("_total_", comment: "") + ": " + "0.00")
    }

    func testStringNotEmpty() {
        XCTAssertFalse(viewModel.getTotalString().isEmpty)
        XCTAssertFalse(viewModel.getSubtotalString().isEmpty)
        XCTAssertFalse(viewModel.getDiscountString().isEmpty)
    }

}
