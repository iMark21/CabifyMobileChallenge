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
    private var promotions: [Promotion]!
    private var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        viewModel = ProductsViewModel.init(repository: MockRepository(), calculator: Calculator())
        promotions = try! MockRepository().fetchPromotions().toBlocking().first()
        products = Products.init(products: try! MockRepository().fetchProducts().toBlocking().first()?.products ?? [])
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
    

    func testProperlyAssigned() {
        //Given products build cellviewmodels
        let viewCellModels = viewModel.buildCellViewModels(data: products)
        
        for rowViewModel in viewCellModels{
            let promotionsToApply = viewModel.getPromotions(promotions: promotions, rowViewModel: rowViewModel)
            //Check is productCodeToApply is the correct one
            for promotion in promotionsToApply {
                XCTAssertEqual(promotion.productCodeApply, rowViewModel.code)
            }
        }
    }
    
    func correctAssignPromotions() {
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
