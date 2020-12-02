//
//  VillagerDetailViewController.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 5/30/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class VillagerDetailViewController: UIViewController {
    var thisVillager:villager?
    

    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var NameTitleLabel: UILabel!
    @IBOutlet weak var SpeciesText: UILabel!
    @IBOutlet weak var GenderText: UILabel!
    @IBOutlet weak var BdayText: UILabel!
    @IBOutlet weak var PersonalityText: UILabel!
    @IBOutlet weak var PhraseText: UILabel!
    @IBOutlet weak var Species: UILabel!
    @IBOutlet weak var Gender: UILabel!
    @IBOutlet weak var Bday: UILabel!
    @IBOutlet weak var Personality: UILabel!
    @IBOutlet weak var Phrase: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageUrl = ""
        imageUrl = "https://acnhcdn.com/latest/FtrIcon/BromideNpcNml" + thisVillager!.filename.capitalized + "_Remake_1_0.png"
        imageSlide.setImageInputs([
                    KingfisherSource(urlString: imageUrl )! as InputSource,
                       //KingfisherSource(urlString: (thisVillager?.villagerItem.iconImage)! )! as InputSource,
                       KingfisherSource(urlString: (thisVillager?.houseImage)!)! as InputSource,
                   ])
        let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
             NameTitleLabel.text = "\(thisVillager!.nameCN)"//getLocalName(bugName: thisVillager.filename)
            
        }
        else{
           NameTitleLabel.text = "\(thisVillager!.name)"//getLocalName(bugName: thisVillager.filename)
        }
        
        SpeciesText.text = "Species".localized()
        GenderText.text = "Gender".localized()
        BdayText.text = "Birthday".localized()
        PersonalityText.text = "Personality".localized()
        PhraseText.text = "Phrase".localized()
        Species.text = "\(thisVillager!.species)".localized()
        Gender.text = "\(thisVillager!.gender)".localized()
        Bday.text = "\(thisVillager!.birthday)".localized()
        Personality.text = "\(thisVillager!.personality)".localized()
        Phrase.text = getLocalPhrase(bugName: (thisVillager?.filename)!).capitalized
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
   
    
    func getLocalPhrase(bugName : String) -> String{
        let bugNameRemoveSpace = bugName.replacingOccurrences(of: " ", with: "_").lowercased() as String?
        let bugNameFix = bugNameRemoveSpace?.replacingOccurrences(of: "'", with: "")
        
        var result = ""
        let url = Bundle.main.url(forResource: "villagers_multilanguage", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try? JSONSerialization.jsonObject(with: jsonData)
            
            if let json = json as? Dictionary<String, AnyObject>
            {
                //    print("bug name is", bugName)
                let bugnames = json[bugNameFix!] as! [String: Any]
                let name = bugnames["catch-translations"] as! [String: Any]
                
                //local name output
                let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
                if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
                    let name_cn = name["catch-CNzh"] as! String
                    result = name_cn
                    //print("bug name from new api is", name_cn)
                }
                else{
                    let name_en = name["catch-USen"] as! String
                    result = name_en
                }
            }
            
        }
        catch {
            print("error in new api")
        }
        return result
    }

}
