//
//  BugsDetailViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/7/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class BugsDetailViewController: UIViewController {
    var thisBug:bug?
    var isNorthHemishere:Bool?
    @IBOutlet private weak var monthCollectionView: UICollectionView!
    
    
    var monthCollectionData = ["1".localized(),"2".localized(),"3".localized(),"4".localized(),"5".localized(),"6".localized(),"7".localized(),"8".localized(),"9".localized(),"10".localized(),"11".localized(),"12".localized()]
    
    
    @IBOutlet weak var imageSlide: ImageSlideshow!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var TimeText: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var Rarity: UILabel!
    @IBOutlet weak var PriceText: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
   
        override func viewDidLoad() {
            super.viewDidLoad()
          //  self.view.backgroundColor = UIColor.customwhite
            
            monthCollectionData = ["1".localized(),"2".localized(),"3".localized(),"4".localized(),"5".localized(),"6".localized(),"7".localized(),"8".localized(),"9".localized(),"10".localized(),"11".localized(),"12".localized()]
            
            
            nameLabel.text = getLocalName(bugName: (thisBug?.bugData.name)!).capitalized
            TimeText.text = "Time".localized()
            locationText.text = "Location".localized()
            weatherText.text = "Weather".localized()
            Rarity.text = "Rarity".localized()
            PriceText.text = "Price".localized()
            
            //isNorthHemishere = UserDefaults.standard.bool(forKey: "NorthHemishere")
            //let width = (view.frame.size.width - 30) / 7
            let layout = monthCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 45, height: 20)
            
            imageSlide.setImageInputs([
                KingfisherSource(urlString: (thisBug?.bugData.iconImageUrl)! )! as InputSource,
                KingfisherSource(urlString: (thisBug?.bugData.furnitureImageUrl)!)! as InputSource,
                KingfisherSource(urlString: (thisBug?.bugData.critterpediaImageUrl)!)! as InputSource
            ])
            
            
            //set up time
            var timelabeltext = ""
            let timeSegment = (thisBug?.bugData.startTime.count)
            if timeSegment == 1 {
                if thisBug?.bugData.startTime[0] == "All day"{
                    timelabeltext = timelabeltext + "All day".localized()
                }
                else{
                    timelabeltext = timelabeltext + formatTo24hour(time12: (thisBug?.bugData.startTime[0])!) + "-" + formatTo24hour(time12: (thisBug?.bugData.endTime[0])!)
                }
            }
            else {
                timelabeltext = timelabeltext + formatTo24hour(time12: (thisBug?.bugData.startTime[0])!) + "-" + formatTo24hour(time12: (thisBug?.bugData.endTime[0])!)
                timelabeltext = timelabeltext + ", " + formatTo24hour(time12: (thisBug?.bugData.startTime[1])!) + "-" + formatTo24hour(time12: (thisBug?.bugData.endTime[1])!)
            }
            timeLabel.text = timelabeltext
            //timeLabel.backgroundColor = UIColor.customyellow
            timeLabel.layer.cornerRadius = 5
            timeLabel.layer.masksToBounds = true
            //set up location
            var location = thisBug?.bugData.location
            switch location {
            case "On trees (any kind)" : location = "On trees (any kind)".localized();
            case "On beach rocks" : location = "On beach rocks".localized();
            case "Flying" : location = "Flying".localized();
            case "On the ground" : location = "On the ground".localized();
            case "On flowers" : location = "On flowers".localized();
            case "On hardwood/cedar trees" : location = "On hardwood/cedar trees".localized();
            case "Flying near water" : location = "Flying near water".localized();
            case "Flying near light sources" : location = "Flying near light sources".localized();
            case "On white flowers" : location = "On white flowers".localized();
            case "Flying near flowers" : location = "Flying near flowers".localized();
            case "On rivers/ponds" : location = "On rivers/ponds".localized();
            case "Underground (dig where noise is loudest)" : location = "Underground (dig where noise is loudest)".localized();
            case "Disguised under trees" : location = "Disguised under trees".localized();
            case "On palm trees" : location = "On palm trees".localized();
            case "On tree stumps" : location = "On tree stumps".localized();
            case "Pushing snowballs" : location = "Pushing snowballs".localized();
            case "Shaking trees (hardwood or cedar only)" : location = "Shaking trees (hardwood or cedar only)".localized();
            case "On villagers" : location = "On villagers".localized();
            case "On rotten turnips" : location = "On rotten turnips".localized();
            case "On rocks/bushes" : location = "On rocks/bushes".localized();
            case "Flying near blue/purple/black flowers" : location = "Flying near blue/purple/black flowers".localized();
            case "From hitting rocks" : location = "From hitting rocks".localized();
            case "Disguised on shoreline" : location = "Disguised on shoreline".localized();
            case "Flying near trash (boots, tires, cans) or rotten turnips" : location = "Flying near trash (boots, tires, cans) or rotten turnips".localized();
            case "Shaking trees" : location = "Shaking trees".localized();
            default: location = "unkown".localized();
            break;
            }
            
            
           
            locationLabel.text = (location)!
            //locationLabel.backgroundColor = UIColor.customyellow
            locationLabel.layer.cornerRadius = 5
            locationLabel.layer.masksToBounds = true
            //
            var weather = thisBug?.bugData.weather
            switch weather {
            case "Any weather" : weather = "Any weather".localized();
            case "Any except rain" : weather = "Any except rain".localized();
            case "Rain only" : weather = "Rain only".localized();
            default: weather = "unkown".localized();
            break;
            }
            weatherLabel.text = (weather)!
            //weatherLabel.backgroundColor = UIColor.customyellow
            weatherLabel.layer.cornerRadius = 5
            weatherLabel.layer.masksToBounds = true
            //
            var rarity = thisBug?.bugData.rarity
            switch rarity {
            case "Common" : rarity = "Common".localized();
            case "Rare" : rarity = "Rare".localized();
            case "Uncommon" : rarity = "Uncommon".localized();
            case "UltraRare" : rarity = "UltraRare".localized();
            default: rarity = "unkown".localized();
            break;
            }
            
            
            rarityLabel.text = (rarity)!
            //rarityLabel.backgroundColor = UIColor.customyellow
            rarityLabel.layer.cornerRadius = 5
            rarityLabel.layer.masksToBounds = true
            priceLabel.text  = "\(thisBug?.bugData.sellPrice ?? 0)"
            //priceLabel.backgroundColor = UIColor.customyellow
            priceLabel.layer.cornerRadius = 5
            priceLabel.layer.masksToBounds = true
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
            let url = Bundle.main.url(forResource: "bug_multilanguage", withExtension: "json")!
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
                        //print("bug name from new api is", name_cn)
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
    //* MARK: - Extension

    extension BugsDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
        

        
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
                    if(((thisBug?.bugData.northernHemisphereMonths[indexPath.row])) == true){
                        //label.isHighlighted = true
                        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
                        label.textColor = .label
                        
                        //label.backgroundColor = UIColor(hex: "#ff9717ff")
                    }
                }
                else{
                    //label.isHighlighted = false
                    label.backgroundColor = UIColor(hex: "#000000")
                    label.textColor = .darkGray
                    label.font = UIFont(name: "HelveticaNeue", size: 15.0)
                    if(((thisBug?.bugData.southernHemisphereMonths[indexPath.row])) == true){
                        //label.isHighlighted = true
                        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
                        label.textColor = .label
                        //label.backgroundColor = UIColor(hex: "#ff9717ff")
                    }
                    
                }
            }
            return cell
        }
        
    }



    //* MARK: - private method
     func formatTo24hour(time12: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: time12)
        dateFormatter.dateFormat = "HH:mm"
        let final = dateFormatter.string(from: date!)
        return final
    }

    extension UIColor {
        public convenience init?(hex: String) {
            let r, g, b, a: CGFloat
            
            if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])
                
                if hexColor.count == 8 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0
                    
                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        a = CGFloat(hexNumber & 0x000000ff) / 255
                        
                        self.init(red: r, green: g, blue: b, alpha: a)
                        return
                    }
                }
            }
            
            return nil
        }
        
        class var customyellow: UIColor {
                let darkGreen = 0xFFDE00
                return UIColor.rgb(fromHex: darkGreen)
            }
        class var customwhite: UIColor {
                      let darkGreen = 0xF5F2F0
                      return UIColor.rgb(fromHex: darkGreen)
                  }
        

            class func rgb(fromHex: Int) -> UIColor {

                let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
                let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
                let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
                let alpha = CGFloat(1.0)

                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        }


    extension String {
        
        func localized(withComment comment: String? = nil) -> String {
            
            let lang = UserDefaults.standard.string(forKey: "i18n_language")
            let path = Bundle.main.path(forResource: lang, ofType: "lproj")
            let bundle = Bundle(path: path!)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
        
        
        
    }


