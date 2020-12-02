//
//  FishDetailViewController.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 5/15/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class FishDetailViewController: UIViewController {
    var thisFish:fish?
    var isNorthHemishere:Bool?
    
    @IBOutlet weak var FishSizeStack: UIStackView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
     var monthCollectionData = ["1".localized(),"2".localized(),"3".localized(),"4".localized(),"5".localized(),"6".localized(),"7".localized(),"8".localized(),"9".localized(),"10".localized(),"11".localized(),"12".localized()]
    
    @IBOutlet weak var size1: UIImageView!
    @IBOutlet weak var size2: UIImageView!
    @IBOutlet weak var size3: UIImageView!
    @IBOutlet weak var size4: UIImageView!
    @IBOutlet weak var size5: UIImageView!
    @IBOutlet weak var size6: UIImageView!
    @IBOutlet weak var size7: UIImageView!
    @IBOutlet weak var size8: UIImageView!
    
    
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var rarityText: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fishNameLabel: UILabel!
    
      
    
        override func viewDidLoad() {
            FishSizeStack.addBackground(color: .white)
            super.viewDidLoad()
           // self.view.backgroundColor = UIColor.customwhite
            navigationItem.largeTitleDisplayMode = .never

          //  monthCollectionData = ["1".localized(),"2".localized(),"3".localized(),"4".localized(),"5".localized(),"6".localized(),"7".localized(),"8".localized(),"9".localized(),"10".localized(),"11".localized(),"12".localized()]
            
            fishNameLabel.text = getLocalFishName(bugName: (thisFish?.fishData.name)!).capitalized
            timeText.text = "Time".localized()
            locationText.text = "Location".localized()
            weatherText.text = "Weather".localized()
            rarityText.text = "Rarity".localized()
            priceText.text = "Price".localized()
            
            //isNorthHemishere = UserDefaults.standard.bool(forKey: "NorthHemishere")
            //let width = (view.frame.size.width - 30) / 7
            let layout = monthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 45, height: 20)
            
            imageSlide.setImageInputs([
                KingfisherSource(urlString: (thisFish?.fishData.iconImageUrl)! )! as InputSource,
                KingfisherSource(urlString: (thisFish?.fishData.furnitureImageUrl)!)! as InputSource,
                KingfisherSource(urlString: (thisFish?.fishData.critterpediaImageUrl)!)! as InputSource
            ])
            
            
            //set up time
            var timelabeltext = ""
            let timeSegment = (thisFish?.fishData.startTime.count)
            if timeSegment == 1 {
                if thisFish?.fishData.startTime[0] == "All day"{
                    timelabeltext = timelabeltext + "All day".localized()
                }
                else{
                    timelabeltext = timelabeltext + formatTo24hour(time12: (thisFish?.fishData.startTime[0])!) + "-" + formatTo24hour(time12: (thisFish?.fishData.endTime[0])!)
                }
            }
            else {
                timelabeltext = timelabeltext + formatTo24hour(time12: (thisFish?.fishData.startTime[0])!) + "-" + formatTo24hour(time12: (thisFish?.fishData.endTime[0])!)
                timelabeltext = timelabeltext + ", " + formatTo24hour(time12: (thisFish?.fishData.startTime[1])!) + "-" + formatTo24hour(time12: (thisFish?.fishData.endTime[1])!)
            }
            timeLabel.text = timelabeltext
            //timeLabel.backgroundColor = UIColor.customyellow
            timeLabel.layer.cornerRadius = 5
            timeLabel.layer.masksToBounds = true
         
            //set up location
            var location = thisFish?.fishData.location
            switch location {

            case "Pond" : location = "Pond".localized();
            case "Sea" : location = "Sea".localized();
            case "River" : location = "River".localized();
            case "River (mouth)" : location = "River (mouth)".localized();
            case "River (clifftop)" : location = "River (clifftop)".localized();
            case "Pier" : location = "Pier".localized();
           
            default: location = "unkown".localized();
            break;
            }
            
            
           
            locationLabel.text = (location)!
            locationLabel.layer.cornerRadius = 5

            //locationLabel.backgroundColor = UIColor.customyellow
            locationLabel.layer.masksToBounds = true


            let weather = thisFish?.fishData.rainSnowOnly
            switch weather{
            case true : weatherLabel.text = "rainSnowOnly".localized()
            case false : weatherLabel.text = "notRainSnowOnly".localized()
            default:  weatherLabel.text = "testing"
            break;
            }
            
            weatherLabel.layer.masksToBounds = true
            weatherLabel.layer.cornerRadius = 5

            
            var rarity = thisFish?.fishData.rarity
            switch rarity {
            case "Common" : rarity = "Common".localized();
            case "Rare" : rarity = "Rare".localized();
            case "Uncommon" : rarity = "Uncommon".localized();
            case "UltraRare" : rarity = "UltraRare".localized();
            default: rarity = "unkown".localized();
            break;
            }
            
            
            rarityLabel.text = (rarity)!
            rarityLabel.layer.cornerRadius = 5
            rarityLabel.layer.masksToBounds = true

            priceLabel.text  = "\(thisFish?.fishData.sellPrice ?? 0)"

            priceLabel.layer.cornerRadius = 5
            priceLabel.layer.masksToBounds = true

            let size = thisFish?.fishData.shadow
            switch size {
            case "XSmall" : size1.alpha = 1;
            case "Small" : size2.alpha = 1;
            case "Medium" : size3.alpha = 1;
            case "Large" : size4.alpha = 1;
            case "XXLarge" : size6.alpha = 1;
            case "XLarge" : size7.alpha = 1;
            case "Long" : size8.alpha = 1;
            case "LargeWFin" : size5.alpha = 1;
            case "MediumWFin" : size5.alpha = 1;
            
            default: rarity = "unkown".localized();
            break;
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
                if(UserDefaults.standard.bool(forKey: "NorthHemishere")) {
                    isNorthHemishere = true;
                }
                else{
                    isNorthHemishere = false;
                }
                //self.monthCollectionView.removeFromSuperview()
                viewDidLoad()
                self.monthCollectionView.reloadData()
                //self.monthCollectionView.removeFromSuperview()
            
            
           }
        
        func getLocalFishName(bugName : String) -> String{
            let bugNameRemoveSpace = bugName.replacingOccurrences(of: " ", with: "_").lowercased() as String?
            let bugNameFix = bugNameRemoveSpace?.replacingOccurrences(of: "'", with: "")
            
            var result = ""
            let url = Bundle.main.url(forResource: "fish_multilanguage", withExtension: "json")!
            do {
                let jsonData = try Data(contentsOf: url)
                let json = try? JSONSerialization.jsonObject(with: jsonData)
                
                if let json = json as? Dictionary<String, AnyObject>
                {
                    //    print("bug name is", bugName)
                    let bugnames = json[bugNameFix!] as! [String: Any]
                    let name = bugnames["name"] as! [String: Any]
                    
                    //local name output
                    let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
                    if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
                        let name_cn = name["name-cn"] as! String
                        result = name_cn
                        
                    }
                    else{
                        let name_en = name["name-en"] as! String
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

    extension FishDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
        

        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return monthCollectionData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath)
            if let label = cell.viewWithTag(100)as? UILabel{
                label.text = monthCollectionData[indexPath.row]
                if(isNorthHemishere!){
                    //label.isHighlighted = false
                    label.backgroundColor = UIColor(hex: "#000000")
                    label.textColor = .darkGray
                    label.font = UIFont(name: "HelveticaNeue", size: 15.0)
                    if(((thisFish?.fishData.northernHemisphereMonths[indexPath.row])) == true){
                        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
                        label.textColor = .label
                    }
                }
                else{
                    //label.isHighlighted = false
                    label.backgroundColor = UIColor(hex: "#000000")
                    label.textColor = .darkGray
                    label.font = UIFont(name: "HelveticaNeue", size: 15.0)
                    if(((thisFish?.fishData.southernHemisphereMonths[indexPath.row])) == true){
                        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
                        label.textColor = .label
                    }
                    
                }
            }
            return cell
        }
        
    }
extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
