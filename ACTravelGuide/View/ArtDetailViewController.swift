//
//  ArtDetailViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/26/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

class ArtDetailViewController: UIViewController {
var thisArt:art?
    
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var realTitleLabel: UILabel!
    @IBOutlet weak var hasRealLabel: UILabel!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var realLabel: UILabel!
    @IBOutlet weak var fakeLabel: UILabel!
    @IBOutlet weak var realSmallImage: UIImageView!
    @IBOutlet weak var fakeSmallImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        artImage.kf.setImage(with: URL(string: thisArt!.trueImage))
        nameLabel.text = getLocalName(bugName: thisArt!.name)
        realTitleLabel.text = thisArt?.realArtworkTitle
        if thisArt!.hasFake {
            hasRealLabel.isHidden = true
            realLabel.text = "真".localized()
            fakeLabel.text = "假".localized()
            let artNameRemoveSpace = thisArt?.name.replacingOccurrences(of: " ", with: "_").lowercased() as String?
            realSmallImage.image = UIImage(named: artNameRemoveSpace!)
            fakeSmallImage.image = UIImage(named: artNameRemoveSpace!+"Fake")
        }
        else{
            imageStackView.isHidden = true
            hasRealLabel.text = "总是真迹".localized()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
         viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getLocalName(bugName : String) -> String{
        let bugNameRemoveSpace = bugName.replacingOccurrences(of: " ", with: "_").lowercased() as String?
        let bugNameFix = bugNameRemoveSpace?.replacingOccurrences(of: "'", with: "")
        
        var result = ""
                    let url = Bundle.main.url(forResource: "art_multilanguage", withExtension: "json")!
                    do {
                        let jsonData = try Data(contentsOf: url)
                        let json = try? JSONSerialization.jsonObject(with: jsonData)
        
                        if let json = json as? Dictionary<String, AnyObject>
                        {
        
                            let bugnames = json[bugNameFix!] as! [String: Any]
                            let name = bugnames["name"] as! [String: Any]
                            
                            //local name output
                            let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
                            if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
                                let name_cn = name["name-CNzh"] as! String
                                result = name_cn
                                //print("bug name from new api is", name_cn)
                            }
                            else{
                                let name_en = name["name-USen"] as! String
                                result = name_en.capitalized
                            }
        
                        }
        
                    }
                    catch {
                        print("error in new api")
                    }
        return result
    }
}
