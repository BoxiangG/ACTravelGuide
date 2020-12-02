//
//  CatalogTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/24/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import RealmSwift

struct shareItem{
    let name:String
    let imageURL:String
}


class CatalogTableViewController: UITableViewController {
    let realm = try! Realm()
    override func viewDidLoad() {
        let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
        
        
        
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView(frame: .zero) //Remove empty cells
        
        
        if isAppAlreadyLaunchedOnce(){
            appLaunchFirstTimeInCurrentVerison()
        }
        else{
            UserDefaults.standard.set(true, forKey: "NorthHemishere")
            loadDataFromLocalFile()
            if(cnLanguageCode.contains(Locale.current.languageCode!)){
                UserDefaults.standard.set("zh", forKey: "i18n_language")
                print("system langua is 中文")
            }
            else{
                UserDefaults.standard.set("en", forKey: "i18n_language")
                print("system langua is eng")
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        title = "Museum".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = "Museum".localized()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func awakeFromNib() {
        
        title = "Museum".localized()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CatalogTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CatalogTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CatalogTableViewCell.")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let selectedRow = indexPath.row
        
        switch selectedRow {
        case 0:
            cell.iconImage.image = UIImage(named: "fish.png")
            cell.catalogName.text = "Fishes".localized()
            cell.numOfItem.text = "80"
        case 1:
            cell.iconImage.image = UIImage(named: "butterfly.png")

            cell.catalogName.text = "Bugs".localized()
            cell.numOfItem.text = "80"
            
        case 2:
            
            cell.iconImage.image = UIImage(named: "fossil.png")

            cell.catalogName.text = "Fossils".localized()
            cell.numOfItem.text = "73"
        case 3:
                     cell.iconImage.image = UIImage(named: "artist.png")

            cell.catalogName.text = "Arts".localized()
            cell.numOfItem.text = "43"
            
        default:
            print(Error.self)
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        var viewController:UIViewController?
        switch selectedRow {
        case 0 : viewController = storyboard?.instantiateViewController(identifier: "FishTableViewController")
        case 1 : viewController = storyboard?.instantiateViewController(identifier: "BugTableViewController")
        case 2 : viewController = storyboard?.instantiateViewController(identifier: "FossilTableViewController")
        case 3 : viewController = storyboard?.instantiateViewController(identifier: "ArtTableViewController")
        default: print(Error.self)
        break;
        }
        
        navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: private Methods
    
    private func loadDataFromLocalFile(){
        
        // load fish data first
        // Current api version v1
        // https://acnh.tnrd.net/api/v1/Fish
        if checkFileExist(fileName: "UserFishesData.json") {
            
        }else {
            var fishes = [fish]()
            do{
                
                let fileURL = Bundle.main.url(forResource: "FishesV1", withExtension: "json")!
                let data = try Data(contentsOf: fileURL)
                let tempFishes = try JSONDecoder().decode([fishItem].self, from: data)
                for index in 0...(tempFishes.count-1) {
                    let thisfish = fish(get: false, creature: tempFishes[index])
                    fishes += [thisfish]
                }
                
                
                do{
                    let fileURL = try FileManager.default
                        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent("UserFishesData.json")
                    try JSONEncoder().encode(fishes.sorted(by:{ $0.fishData.number < $1.fishData.number})).write(to: fileURL)
                }
                catch{
                    print(error)
                }
                
            }
            catch {
                print(error)
            }
        }
        
        
        // load bug
        // Current api version v1
        // https://acnh.tnrd.net/api/v1/Bugs
        if checkFileExist(fileName: "UserBugsData.json") {
            
        }else {
            var bugs = [bug]()
            
            do{
                let fileURL = Bundle.main.url(forResource: "BugsV1", withExtension: "json")!
                let data = try Data(contentsOf: fileURL)
                let tempBugs = try JSONDecoder().decode([bugItem].self, from: data)
                for index in 0...(tempBugs.count-1) {
                    let thisbug = bug(get: false, creature: tempBugs[index])
                    bugs += [thisbug]
                }
            }
            catch{
                print("Error")
            }
            do{
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("UserBugsData.json")
                try JSONEncoder().encode(bugs.sorted(by:{ $0.bugData.number < $1.bugData.number})).write(to: fileURL)
            }
            catch{
                print(error)
            }
        }
        
        // load art
        // Current api version v3
        // https://acnh.tnrd.net/api/v3/Arts
        if checkFileExist(fileName: "UserArtsData.json") {
            
        }else {
            var arts = [art]()
            
            do{
                let fileURL = Bundle.main.url(forResource: "ArtsV3", withExtension: "json")!
                let data = try Data(contentsOf: fileURL)
                var tempArts = try JSONDecoder().decode([artItem].self, from: data)
                
                
                while tempArts.count > 0 {
                    let nameOfArt = tempArts[0].name
                    let realArtworkTitle = tempArts[0].realArtworkTitle
                    let trueImage:String
                    let hasFake:Bool
                    let fakeImage:String?
                    
                    let indexArray = tempArts.indices.filter { tempArts[$0].name.localizedCaseInsensitiveContains(nameOfArt) }
                    
                    if indexArray.count == 2 {
                        hasFake = true
                        if tempArts[0].genuine {
                            trueImage = tempArts[0].image
                            fakeImage = tempArts[indexArray[1]].image
                        }
                        else{
                            trueImage = tempArts[indexArray[1]].image
                            fakeImage = tempArts[0].image
                        }
                        tempArts.remove(at: indexArray[1])
                        tempArts.remove(at: 0)
                        
                    }
                    else{
                        hasFake = false
                        trueImage = tempArts[0].image
                        fakeImage = nil
                        tempArts.remove(at: 0)
                        
                    }
                    
                    let thisart = art(donated: false, name: nameOfArt, realArtworkTitle: realArtworkTitle, hasFake: hasFake, trueImage: trueImage, fakeImage: fakeImage)
                    arts += [thisart]
                    
                }
                
            }
            catch{
                print(error)
            }
            do{
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("UserArtsData.json")
                try JSONEncoder().encode(arts).write(to: fileURL)
            }
            catch{
                print(error)
            }
        }
        
        
        loadVillagerAndReaction()
        loadRug()
    }
    
    func    loadVillagerAndReaction()
    {
        // 1.1.0 version
        
        // load fossil
        // Current api version v3
        // https://acnh.tnrd.net/api/v3/Fossils
        
        if checkFileExist(fileName: "UserFossilsData.json") {
            class oldFossil: Codable{
                var get:Bool
                let fossilData:fossilItem
                
                //MARK: Initialization
                init(donated:Bool,creature:fossilItem){
                    self.get = false
                    self.fossilData = creature}}
            do{
                
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("UserFossilsData.json")
                let data = try Data(contentsOf: fileURL)
                let tempFossils = try JSONDecoder().decode([oldFossil].self, from: data)
                for index in 0...(tempFossils.count-1) {
                    let tempFossil = fossil()
                    tempFossil.donated = tempFossils[index].get
                    tempFossil.name = tempFossils[index].fossilData.name
                    tempFossil.image = tempFossils[index].fossilData.image
                    tempFossil.price = tempFossils[index].fossilData.sell
                    tempFossil.internalID = tempFossils[index].fossilData.internalID
                    tempFossil.namezhCN = getfossilCNName(bugName : tempFossils[index].fossilData.name)
                    try! realm.write {
                        realm.add(tempFossil)
                    }
                }
                
            }
            catch{
                print(error)
            }
            delete(fileName: "UserFossilsData.json")
            
        }else {
            
            do{
                let fileURL = Bundle.main.url(forResource: "FossilsV3", withExtension: "json")!
                let data = try Data(contentsOf: fileURL)
                let tempFossils = try JSONDecoder().decode([fossilItem].self, from: data)
                for index in 0...(tempFossils.count-1) {
                    let tempFossil = fossil()
                    tempFossil.name = tempFossils[index].name
                    tempFossil.image = tempFossils[index].image
                    tempFossil.price = tempFossils[index].sell
                    tempFossil.internalID = tempFossils[index].internalID
                    tempFossil.namezhCN = getfossilCNName(bugName : tempFossils[index].name)
                    try! realm.write {
                        realm.add(tempFossil)
                    }
                }
                
            }
            catch{
                print(error)
            }
            
        }
        
        do{
            let fileURL = Bundle.main.url(forResource: "VillagersV3", withExtension: "json")!
            let data = try Data(contentsOf: fileURL)
            let tempVillagers = try JSONDecoder().decode([villagerItem].self, from: data)
            for index in 0...(tempVillagers.count-1) {
                
                let Villager = villager()
                Villager.nameCN = getVillagerCNName(bugName : tempVillagers[index].filename)
                Villager.name = tempVillagers[index].name
                Villager.iconImage = tempVillagers[index].iconImage
                Villager.houseImage = tempVillagers[index].houseImage
                Villager.species = tempVillagers[index].species
                Villager.gender = tempVillagers[index].gender
                Villager.personality = tempVillagers[index].personality
                Villager.hobby = tempVillagers[index].hobby
                Villager.birthday = tempVillagers[index].birthday
                Villager.phrase = tempVillagers[index].catchphrase
                Villager.favoriteSong = tempVillagers[index].favoriteSong
                Villager.style1 = tempVillagers[index].style1
                Villager.style2 = tempVillagers[index].style2
                Villager.color1 = tempVillagers[index].color1
                Villager.color2 = tempVillagers[index].color2
                Villager.wallpaper = tempVillagers[index].wallpaper
                Villager.flooring = tempVillagers[index].flooring
                
                var furnitureListfromArray = List<String>()
                for furniture in tempVillagers[index].furnitureList{
                    furnitureListfromArray.append(furniture)
                }
                Villager.furnitureList = furnitureListfromArray
                Villager.filename = tempVillagers[index].filename
                Villager.uniqueEntryID = tempVillagers[index].uniqueEntryID
                try! realm.write {
                    realm.add(Villager)
                }
            }
            
        }
        catch{
            print("Error")
        }
        do{
            let fileURL = Bundle.main.url(forResource: "ReactionV3", withExtension: "json")!
            let data = try Data(contentsOf: fileURL)
            let tempReactions = try JSONDecoder().decode([reactionItem].self, from: data)
            for index in 0...(tempReactions.count-1) {
                let tempReaction = reaction()
                tempReaction.name = tempReactions[index].name
                tempReaction.nameCN = getReactionCNName(reactionName: tempReactions[index].name)
                tempReaction.image = tempReactions[index].image
                tempReaction.source.append(objectsIn:tempReactions[index].source )
                tempReaction.sourceNotes = tempReactions[index].sourceNotes
                tempReaction.uniqueEntryID = tempReactions[index].uniqueEntryID
                try! realm.write {
                    realm.add(tempReaction)
                }
            }
            
        }
        catch{
            print(error)
        }
        
    }
    
    func loadRug(){
        do{
            let fileURL = Bundle.main.url(forResource: "RugsV3", withExtension: "json")!
            let data = try Data(contentsOf: fileURL)
            let temp = try JSONDecoder().decode([rugItem].self, from: data)
            for index in 0...(temp.count-1) {
                let tempRug = RugAndWall()
                tempRug.name = temp[index].name
                tempRug.nameCN = getRugCNName(itemName: temp[index].name)
                tempRug.image = temp[index].image
                tempRug.sell = temp[index].sell
                tempRug.size = temp[index].size
                tempRug.tag = temp[index].tag
                tempRug.source.append(objectsIn:temp[index].source )
                tempRug.hhaSeries = temp[index].hhaSeries
                tempRug.sourceNotes = temp[index].sourceNotes
                tempRug.uniqueEntryID = temp[index].uniqueEntryID
                tempRug.catalog = temp[index].catalog
                try! realm.write {
                    realm.add(tempRug)
                }
            }
        }
        catch{
            print(error)
        }
        do{
                   let fileURL = Bundle.main.url(forResource: "wallpaperV3", withExtension: "json")!
                   let data = try Data(contentsOf: fileURL)
                   let temp = try JSONDecoder().decode([wallPaperItem].self, from: data)
                   for index in 0...(temp.count-1) {
                       let tempWallpaper = RugAndWall()
                       tempWallpaper.name = temp[index].name
                    tempWallpaper.nameCN = getRugCNName(itemName: temp[index].name)
                       tempWallpaper.image = temp[index].image
                        tempWallpaper.sell = temp[index].sell
                       //tempRug.size = temp[index].size
                       tempWallpaper.tag = temp[index].tag
                       tempWallpaper.source.append(objectsIn:temp[index].source )
                       tempWallpaper.hhaSeries = temp[index].hhaSeries
                       tempWallpaper.sourceNotes = temp[index].sourceNotes
                       tempWallpaper.uniqueEntryID = temp[index].uniqueEntryID
                       tempWallpaper.catalog = temp[index].catalog
                       try! realm.write {
                           realm.add(tempWallpaper)
                       }
                   }
               }
        catch{
                   print(error)
               }
        
    }
    
    func getVillagerCNName(bugName : String) -> String{
        let bugNameRemoveSpace = bugName.replacingOccurrences(of: " ", with: "_").lowercased() as String?
        let bugNameFix = bugNameRemoveSpace?.replacingOccurrences(of: "'", with: "")
        
        var result = ""
        let url = Bundle.main.url(forResource: "villagers_multilanguage", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try? JSONSerialization.jsonObject(with: jsonData)
            
            if let json = json as? Dictionary<String, AnyObject>
            {
                let bugnames = json[bugNameFix!] as! [String: Any]
                let name = bugnames["name"] as! [String: Any]
                let name_cn = name["name-CNzh"] as! String
                result = name_cn
            }
            
        }
        catch {
            print("error in new api")
        }
        return result
    }
    func getfossilCNName(bugName : String) -> String{
        let bugNameRemoveSpace = bugName.replacingOccurrences(of: " ", with: "_").lowercased() as String?
        let bugNameFix = bugNameRemoveSpace?.replacingOccurrences(of: "._", with: "")
        
        var result = ""
        let url = Bundle.main.url(forResource: "fossil_multilanguage", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try? JSONSerialization.jsonObject(with: jsonData)
            
            if let json = json as? Dictionary<String, AnyObject>
            {
                
                let bugnames = json[bugNameFix!] as! [String: Any]
                let name = bugnames["name"] as! [String: Any]
                let name_cn = name["name-CNzh"] as! String
                result = name_cn
            }
            
        }
        catch {
            print("error in new api")
        }
        return result
    }
    private func getReactionCNName(reactionName : String) -> String{
        var result = ""
        do{
            let fileURL = Bundle.main.url(forResource: "reactions_multilanguage", withExtension: "json")!
            let data = try Data(contentsOf: fileURL)
            let tempreactions = try JSONDecoder().decode([reactionMultiLanguage].self, from: data)
            for reactionMultiLanguage in tempreactions {
                if reactionName == reactionMultiLanguage.locale.USen{
                    result = reactionMultiLanguage.locale.CNzh
                }
            }
            
        }
        catch{
            print(error)
        }
        return result
    }
    
    private func getRugCNName(itemName : String) -> String{
        var result = ""
        do{
            let fileURL = Bundle.main.url(forResource: "RugAndWall-multilanguage", withExtension: "json")!
            let data = try Data(contentsOf: fileURL)
            let tempreactions = try JSONDecoder().decode([reactionMultiLanguage].self, from: data)
            for reactionMultiLanguage in tempreactions {
                if itemName == reactionMultiLanguage.locale.USen{
                    result = reactionMultiLanguage.locale.CNzh
                }
            }
            
        }
        catch{
            print(error)
        }
        return result
    }
    
    func appLaunchFirstTimeInCurrentVerison(){
        let existingVersion = UserDefaults.standard.object(forKey: "CurrentVersionNumber") as? String
        let appVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        if existingVersion != appVersionNumber {
            print("existingVersion = \(String(describing: existingVersion))")
            UserDefaults.standard.set(appVersionNumber, forKey: "CurrentVersionNumber")
            loadVillagerAndReaction()
            loadRug()
        }
    }
    func delete(fileName : String)->Bool{
        
        
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(fileName)
            try FileManager.default.removeItem(at: fileURL)
            print("File deleted")
            return true
        }
        catch {
            print("Error")
        }
        return false
    }
}

private extension CatalogTableViewController{
    func checkFileExist(fileName : String)->Bool{
        let documentDirectoryURL = try! FileManager.default.url(for: .applicationSupportDirectory,in: .userDomainMask,appropriateFor: nil,create: true)
        let databaseURL = documentDirectoryURL.appendingPathComponent(fileName)
        var fileExists: Bool = false
        do {
            fileExists = try databaseURL.checkResourceIsReachable()
            
            // handle the boolean result
        } catch let error as NSError {
            print(error)
        }
        return fileExists
    }
}

func isAppAlreadyLaunchedOnce()->Bool{
    let defaults = UserDefaults.standard
    if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
        print("App already launched")
        return true
    }else{
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App launched first time")
        return false
    }
}

