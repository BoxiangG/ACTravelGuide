//
//  ReactionDetailViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 6/2/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

class ReactionDetailViewController: UIViewController {
    var thisReaction: reaction?
    var isChinese = false
    let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.kf.setImage(with: URL(string: thisReaction!.image))

        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
            isChinese = true
            nameLabel.text = thisReaction?.nameCN
        }else{
            nameLabel.text = thisReaction?.name

        }
        Label1.text = "Source".localized()
        Label2.text = "Additional Info".localized()
        sourceLabel.text = (thisReaction?.source[0].localized())! + "reactionSource".localized()
        if thisReaction?.sourceNotes == nil{
        noteLabel.text = "None".localized()

        }else{
        noteLabel.text = thisReaction?.sourceNotes?.localized()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
