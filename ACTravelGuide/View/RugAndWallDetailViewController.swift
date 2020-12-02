//
//  RugAndWallDetailViewController.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 6/8/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class RugAndWallDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var text5: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var thisItem: RugAndWall?
    let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
    var isChinese = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: URL(string: thisItem!.image))
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
                  isChinese = true
                  nameLabel.text = thisItem?.nameCN
              }else{
            nameLabel.text = thisItem?.name.capitalized

              }
        
        text1.text = "Series".localized()
        text2.text = "Price".localized()
        text3.text = "Source".localized()
        text4.text = "Notes".localized()
        text5.text = "Size".localized()
        
        if thisItem?.hhaSeries == "None"{
            label1.isHidden = true
            text1.isHidden = true
        }
        else{
            label1.text = thisItem?.hhaSeries?.localized().capitalized
        }
        label2.text = "\(thisItem?.sell ?? 0)"
        label3.text = thisItem?.source[0].localized()
        if thisItem?.sourceNotes == nil{
            //label4.text = "None".localized()
            text4.isHidden = true
            label4.isHidden = true
        }
        else{
            label4.text = thisItem?.sourceNotes?.localized()
        }
        if thisItem?.size == nil{
            //disable display of label
            text5.isHidden = true
            label5.isHidden = true
        }
        else{
            label5.text = thisItem?.size
        }
        
       
        
        
    }
    

}
