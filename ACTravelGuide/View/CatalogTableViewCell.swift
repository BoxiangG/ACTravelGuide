//
//  CatalogTableViewCell.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/24/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
  
    @IBOutlet weak var catalogName: UILabel!
    
    @IBOutlet weak var numOfItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
