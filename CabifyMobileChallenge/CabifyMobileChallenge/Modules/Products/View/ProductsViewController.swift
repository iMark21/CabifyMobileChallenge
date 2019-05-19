//
//  ProductsViewController.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    var viewModel : ProductsViewModel?
    var cellViewModels : [ProductCellViewModel] = []
    let loadingViewController = LoadingViewController()
    let errorViewController = ErrorViewController()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViewModel()
        requestData()
    }
    
    func configureView (){
        self.title = NSLocalizedString("", comment: "")
        configureNavBar()
        configureTableView()
    }
    
    func configureCalculateView(){
        guard let viewModel = viewModel else {return}
        viewModel.calculateTotal()
        self.totalValueLabel.text = viewModel.totalString
        self.subtotalLabel.text = viewModel.subtotalString
        self.discountLabel.text = viewModel.discountString

    }
    
    func configureNavBar(){
        let resetBar = UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(resetAction))
        let reloadBar = UIBarButtonItem(barButtonSystemItem: .refresh , target: self, action: #selector(reloadAction))
        navigationItem.rightBarButtonItem = reloadBar
        navigationItem.leftBarButtonItem = resetBar
    }
    
    func configureTableView(){
        tableView.register(UINib(nibName: CellIdentifiers.ProductTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.ProductTableViewCell)
    }
    
    func setupViewModel(){
        guard let viewModel = viewModel else {return}
        let state = viewModel.state.asObservable()
        state.subscribe(onNext: { (state) in
            switch state{
            case .loaded(let cellViewModels):                
                self.cellViewModels = cellViewModels
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.configureCalculateView()
                self.errorViewController.remove()
                self.loadingViewController.remove()
                break
            case .loading:
                self.tableView.isHidden = true
                self.errorViewController.remove()
                self.add(child: self.loadingViewController)
                break
            case .error:
                self.loadingViewController.remove()
                self.add(child: self.errorViewController)
                break
            case .empty:
                break
            }
        }).disposed(by: disposeBag)
        
    }
    
    func requestData () {
        guard let vm = viewModel else {return}
        vm.requestData()
    }
    
    @objc func resetAction(){
        guard let vm = viewModel else {return}
        vm.resetQuantities()
    }
    
    @objc func reloadAction(){
        viewModel?.requestData()
    }
}

extension ProductsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ProductTableViewCell, for: indexPath)
        if let cell = cell as? ProductTableViewCell{
            let rowViewModel = cellViewModels[indexPath.row]
            cell.setup(viewModel: rowViewModel)
            
            rowViewModel.unitButtonTapped
                .asObserver()
                .subscribe(onNext: { (quantity) in
                    self.configureCalculateView()
                }).disposed(by: disposeBag)
        }
        return cell
    }
}
