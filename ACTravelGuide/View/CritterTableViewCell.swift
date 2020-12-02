//
//  CritterTableViewCell.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/5/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

protocol CritterCellDelegate {
    func didTapgetButton(at index:IndexPath)
    func didTapFavButton(at index: IndexPath)
}

class CritterTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ImageLabel: UIImageView!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var realTitle: UILabel!
    @IBOutlet weak var FavButton: UIButton!
    
    @IBOutlet weak var artGenuineLabel: UILabel!
    
    var indexPath:IndexPath!
    var alreadyget:Bool!
    var delegate: CritterCellDelegate?
    
    @IBAction func getButton(_ sender: Any) {
        delegate?.didTapgetButton(at: indexPath)
    }
    
    @IBAction func tappedFavButton(_ sender: Any) {
         delegate?.didTapFavButton(at: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
