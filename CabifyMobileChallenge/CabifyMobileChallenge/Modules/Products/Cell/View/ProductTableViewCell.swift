//
//  ProductsTableViewCell.swift
//  CabifyMobileChallenge
//
//  Created by Juan Miguel Marqués Morilla on 18/05/2019.
//  Copyright © 2019 Míchel Marqués Morilla. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    private var viewModel : ProductCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup (viewModel: ProductCellViewModel?){
        self.viewModel = viewModel
        configureView()
    }
    
    private func configureView(){
        guard let viewModel = viewModel else {return}
        nameLabel?.text = viewModel.name.uppercased()
        priceLabel?.text = NSLocalizedString("_price_", comment: "") + ": " + viewModel.price
        unitsLabel?.text = "\(viewModel.quantity)"
    }
    

    @IBAction func addItemAction(_ sender: Any) {
        viewModel?.addProduct()
        configureView()
    }
    
    @IBAction func deleteItemAction(_ sender: Any) {
        viewModel?.deleteProduct()
        configureView()
    }
    
}
