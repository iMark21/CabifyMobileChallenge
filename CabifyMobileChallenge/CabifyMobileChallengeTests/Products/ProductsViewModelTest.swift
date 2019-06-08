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
    private var cellViewModels: [ProductCellViewModel]!
    private var apiClient: APIClient!
    private var products: Products!
    private var promotions: [Promotion]!
    private var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        apiClient = APIClient()
        viewModel = ProductsViewModel.init(repository: MockRepository(apiClient: apiClient), calculator: Calculator())
        promotions = try! MockRepository(apiClient: apiClient).fetchPromotions().toBlocking().first()
        products = Products.init(products: try! MockRepository(apiClient: apiClient).fetchProducts().toBlocking().first()?.products ?? [])
        
        for product in products.products {
            for promo in promotions{
                if product.code == promo.productCodeApply{
                    //product.promotions?.append(promo)
                }
            }
            //cellViewModels.append(ProductCellViewModel.init(product: product))
        }
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
        let state = viewModel.state.asObservable()
        state.subscribe(onNext: { (state) in
            switch state {
            case .loaded(let cellViewModels):
                self.cellViewModels = cellViewModels
                //Then
                XCTAssertTrue(self.cellViewModels[0].code == self.products.products[0].code)
                XCTAssertTrue(self.cellViewModels[1].code == self.products.products[1].code)
                XCTAssertTrue(self.cellViewModels[2].code == self.products.products[2].code)
            case .loading:
                break
            case .error:
                break
            case .empty:
                break
            }
        }).disposed(by: disposeBag)


    }

    func testStateSubscribeOnNext() {
        let state = viewModel.state

        let collector = RxCollector<ProductsViewState>()
            .collect(from: state.asObservable())
        state.onNext((.loading))
        state.onNext((.loaded(self.cellViewModels)))
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
