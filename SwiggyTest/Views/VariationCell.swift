//
//  VariationCell.swift
//  SwiggyTest
//
//  Created by Ganesh Patro on 8/3/18.
//  Copyright © 2018 Ganesh Patro. All rights reserved.
//

import UIKit

class VariationCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//MARK:- BaseTableViewCell Protocol
extension VariationCell: BaseTableViewCellProtocol {
    typealias CellConfigurationType = Variant
    
    static func cellNibName() -> String {
        return "VariationCell"
    }
    
    static func cellIdentifier() -> String {
        return "VariationCell"
    }
    
    static func cellHeight() -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func configureCell(withData data: VariationCell.CellConfigurationType, atIndexPath indexPath: NSIndexPath) {
        lblName.text = "Name : " + data.name
        lblPrice.text = "Price : " + String.init(data.price)
        lblStock.text = "In Stock : " + String.init(data.inStock)
    }
}
