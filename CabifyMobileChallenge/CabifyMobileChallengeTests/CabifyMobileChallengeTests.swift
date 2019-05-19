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

class CabifyMobileChallengeTests: XCTestCase {
    
    private var viewModel : ProductsViewModel!
    private var products : Products!
    private let disposeBag = DisposeBag()

    override func setUp() {
        viewModel = ProductsViewModel.init(repository: MockRepository())
        
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

    func testViewModelInit(){
        XCTAssertTrue(viewModel != nil)
    }
    
    func testLoadCase(){
        viewModel.requestData()
        viewModel.calculateTotal()
        XCTAssertTrue(viewModel?.totalString == NSLocalizedString("_total_", comment: "") + ": " + "0.00")
    }
    
    
    func testBuyOneOfEachItemListCase(){
        //Given
        viewModel.requestData()
        
        //When try to buy one item of each one of the list
        for rowViewModel in viewModel.viewModels {
            rowViewModel.quantity = 1;
        }
    
        //Then
        viewModel.calculateTotal()
        XCTAssertTrue(viewModel.totalString == NSLocalizedString("_total_", comment: "") + ": " + "32.50")

    }
    
    func test2voucher1tshirt(){
        //Given
        viewModel.requestData()
        
        //When try to buy 2 Voucher and 1 Tshirt
        for rowViewModel in viewModel.viewModels {
            if rowViewModel.code == "VOUCHER"{
                rowViewModel.quantity = 2;
            }
            
            if rowViewModel.code == "TSHIRT"{
                rowViewModel.quantity = 1;
            }
        }
        
        //Then
        viewModel.calculateTotal()
        XCTAssertTrue(viewModel.totalString == NSLocalizedString("_total_", comment: "") + ": " + "25.00")
        
    }
    
    func test3voucher3tshirt1mug(){
        //Given
        viewModel.requestData()
        
        //When try to buy 3 Voucher, 3 Tshirt and 1 mug
        for rowViewModel in viewModel.viewModels {
            if rowViewModel.code == "VOUCHER"{
                rowViewModel.quantity = 3;
            }else if rowViewModel.code == "TSHIRT"{
                rowViewModel.quantity = 3;
            }else{
                rowViewModel.quantity = 1
            }
        }
        
        //Then
        viewModel.calculateTotal()
        XCTAssertTrue(viewModel.totalString == NSLocalizedString("_total_", comment: "") + ": " + "74.50")
        
    }

}

private final class MockRepository : ProductsRepository {
    
    override func fetchProducts() -> Observable<Products> {
        
        let voucherProduct = Product.init(code: "VOUCHER",
                                          name: "Cabify Voucher",
                                          price: 5.0)
        let tshirtProduct = Product.init(code: "TSHIRT",
                                         name: "Cabify T-Shirt",
                                         price: 20.0)
        let mugProduct = Product.init(code: "MUG",
                                      name: "Cabify Coffee Mug",
                                      price: 7.5)
        
        let products = Products.init(products: [voucherProduct,
                                                tshirtProduct,
                                                mugProduct])
        
        
        return .just(products)
    }
}
