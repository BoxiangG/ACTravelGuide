//
//  FirstViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 4/12/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

class FishTableViewController: UITableViewController, UIActionSheetDelegate{
    
    
    //MARK: - Properties
    var fishes = [fish]()
    var filterdFish: [[fish]] = [[],[]]
    var searchedfilterdFish: [[fish]] = [[],[]]
    var searchedFish: [fish] = []
    var isFilteredInDonated:Bool = false
    var isFilteredInCurrentMonth:Bool = false
    let defaults = UserDefaults.standard
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    @IBAction func tappedSortButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "根据...排序".localized(), preferredStyle: .actionSheet)
               
               alert.addAction(UIAlertAction(title: "Price".localized(), style: .default , handler:{ (UIAlertAction)in
                   self.fishes = self.fishes.sorted(by: { $0.fishData.sellPrice > $1.fishData.sellPrice })
                if self.isFilteredInDonated || self.isFilteredInCurrentMonth{
                    self.filterdFish[0] = self.filterdFish[0].sorted(by: { $0.fishData.sellPrice > $1.fishData.sellPrice })
                    self.filterdFish[1] = self.filterdFish[1].sorted(by: { $0.fishData.sellPrice > $1.fishData.sellPrice })
                }
                    self.tableView.reloadData()
               }))
        
            alert.addAction(UIAlertAction(title: "Name".localized(), style: .default , handler:{ (UIAlertAction)in
                 self.fishes = self.fishes.sorted(by: { self.initialChar(self.getLocalName(bugName: $0.fishData.name)).capitalized < self.initialChar(self.getLocalName(bugName: $1.fishData.name)).capitalized })
                               if self.isFilteredInDonated || self.isFilteredInCurrentMonth{
                                   self.filterdFish[0] = self.filterdFish[0].sorted(by: { self.initialChar(self.getLocalName(bugName: $0.fishData.name)) < self.initialChar(self.getLocalName(bugName: $1.fishData.name)) })
                                   self.filterdFish[1] = self.filterdFish[1].sorted(by: { self.initialChar(self.getLocalName(bugName: $0.fishData.name)) < self.initialChar(self.getLocalName(bugName: $1.fishData.name)) })
                               }
                 self.tableView.reloadData()
            }))

        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @IBAction func filterButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "根据...分组".localized(), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "不分组".localized(), style: .default , handler:{ (UIAlertAction)in
            self.isFilteredInDonated = false
            self.isFilteredInCurrentMonth = false
            self.updateFilter()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "捐赠".localized(), style: .default , handler:{ (UIAlertAction)in
            self.isFilteredInDonated = true
            self.isFilteredInCurrentMonth = false
            self.updateFilter()
        }))
        
        alert.addAction(UIAlertAction(title: "本月可捕捉".localized(), style: .default , handler:{ (UIAlertAction)in
            self.isFilteredInCurrentMonth = true
            self.isFilteredInDonated = false
            self.updateFilter()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler:{ (UIAlertAction)in
            
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    override func viewDidLoad() {
        self.title = "Fishes".localized()
        super.viewDidLoad()
        
        load()
        
        tableView.rowHeight = 60
        sortButton.image = UIImage(systemName:"arrow.up.arrow.down.circle")
        
        // searchbar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Fishes".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if(segue.identifier == "showDetail"){
    //            let selectedBug = bugs[indexPath.row]
    //
    //
    //            BugsDetailViewController.bug = selectedBug
    //        }
    //    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedFish:fish
        if isSearching {
            if isFilteredInDonated || isFilteredInCurrentMonth{
                selectedFish = searchedfilterdFish[indexPath.section][indexPath.row]
            }
            else{
                selectedFish = searchedFish[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated || isFilteredInCurrentMonth{
                selectedFish = filterdFish[indexPath.section][indexPath.row]
            }
            else{
                selectedFish = fishes[indexPath.row]
            }
            
        }
        
        if let viewController = storyboard?.instantiateViewController(identifier: "FishDetailViewController") as? FishDetailViewController {
            viewController.thisFish = selectedFish
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFilteredInDonated{
            if section == 0 {
                return "Not donated".localized()
            }
            else {
                return "Donated".localized()
            }
        }else if isFilteredInCurrentMonth{
            if section == 0 {
                return "本月可捕捉".localized()
            }
            else{
                return "本月不可捕捉".localized()
            }
        }
        return nil
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFilteredInDonated || isFilteredInCurrentMonth{
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if isFilteredInDonated || isFilteredInCurrentMonth{
                return searchedfilterdFish[section].count
            }
            return searchedFish.count
        }
        else{
            if isFilteredInDonated || isFilteredInCurrentMonth{
                return filterdFish[section].count
            }
        }
        return fishes.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CritterTableViewCell"
        
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CritterTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CritterTableViewCell.")
        }
        // cell.backgroundColor = .customwhite
        cell.accessoryType = .disclosureIndicator
        cell.delegate=self
        cell.indexPath = indexPath
        var thisfish:fish
        
        if isSearching {
            if isFilteredInDonated || isFilteredInCurrentMonth{
                thisfish = searchedfilterdFish[indexPath.section][indexPath.row]
            }
            else{
                thisfish = searchedFish[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated || isFilteredInCurrentMonth{
                thisfish = filterdFish[indexPath.section][indexPath.row]
            }
            else{
                thisfish = fishes[indexPath.row]
            }
            
        }
 
        cell.nameLabel.text = getLocalName(bugName: thisfish.fishData.name)
        
        
        cell.priceLabel.text = "\(thisfish.fishData.sellPrice)"
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.textAlignment = .left
        
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if  thisfish.get {
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
            
        }
        else{
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
        }
        
        
        cell.ImageLabel.kf.setImage(with: URL(string: thisfish.fishData.iconImageUrl))
        return cell
    }
    
    
    
    func getLocalName(bugName : String) -> String{
        let bugNameRemoveSpace = bugName.replacingOccurrences(of: " ", with: "_").lowercased() as String?
        let bugNameFix = bugNameRemoveSpace?.replacingOccurrences(of: "'", with: "")
        
        var result = ""
        let url = Bundle.main.url(forResource: "fish_multilanguage", withExtension: "json")!
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
                    let name_cn = name["name-cn"] as! String
                    result = name_cn
                    //print("bug name from new api is", name_cn)
                }
                else if(UserDefaults.standard.string(forKey: "i18n_language") == "en"){
                    let name_en = name["name-en"] as! String
                    result = name_en.capitalized
                    //print("bug name from new api is", name_en)
                }
                
            }
            
        }
        catch {
            print("error in new api")
        }
        return result
    }
    
    //MARK: - Private Function
    
    private func updateFilter(){
        if isFilteredInDonated || isFilteredInCurrentMonth
        {
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
        }
        else
        {
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle")
        }
        updateArray()
        self.tableView.reloadData()
        
    }
    
    private func updateArray(){
        self.filterdFish.removeAll()
        self.filterdFish.append([fish]())
        self.filterdFish.append([fish]())
        
        if isFilteredInDonated{
            for fish in fishes{
                if fish.get {
                    filterdFish[1].append(fish)
                }
                else{
                    filterdFish[0].append(fish)
                }
            }
        }else if isFilteredInCurrentMonth{
            let currentDate = Date()
            let index = Calendar.current.component(.month, from: currentDate)
            if UserDefaults.standard.bool(forKey: "NorthHemishere"){
                for fish in fishes{
                    if fish.fishData.northernHemisphereMonths[index-1] {
                        filterdFish[0].append(fish)
                    }
                    else{
                        filterdFish[1].append(fish)
                    }
                }
                
            }
            else{
                for fish in fishes{
                    if fish.fishData.southernHemisphereMonths[index-1] {
                        filterdFish[0].append(fish)
                        
                    }
                    else{
                        filterdFish[1].append(fish)
                    }
                }
            }
            
            
        }
    }
    
    private func save(fish:[fish]){
        
        do{
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("UserFishesData.json")
            try JSONEncoder().encode(fish).write(to: fileURL)
        }
        catch{
            print(error)
        }
    }
    
    private func load(){
        
        do{
            filterdFish.removeAll()
            fishes.removeAll()
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("UserFishesData.json")
            let data = try Data(contentsOf: fileURL)
            let fishes = try JSONDecoder().decode([fish].self, from: data)
            self.fishes = fishes
            updateArray()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(error)
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        var index = 0
        //  let maxIndex:Int
        if isFilteredInDonated || isFilteredInCurrentMonth{
            
            for _ in filterdFish{
                searchedfilterdFish[index] = filterdFish[index].filter { (fish: fish) -> Bool in
                    return getLocalName(bugName: fish.fishData.name).lowercased().contains(searchText.lowercased())
                }
                index += 1
            }
        }
        else{
            searchedFish = fishes.filter { (fish: fish) -> Bool in
                return getLocalName(bugName: fish.fishData.name).lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    func initialChar(_ chineseString:String) -> String {
        let temp:CFMutableString = CFStringCreateMutableCopy(nil, 0, chineseString as CFString);
        CFStringTransform(temp, nil, kCFStringTransformToLatin, false)
        CFStringTransform(temp, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = temp as String
        guard let result = CFStringCreateWithSubstring(nil, temp, CFRangeMake(0, 1)) else { return ""}
        return pinyin as String
    }
    
    
    
}

extension FishTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


extension FishTableViewController: CritterCellDelegate{
    func didTapFavButton(at index: IndexPath) {
        
    }
    
    
    func didTapgetButton(at index: IndexPath) {
        
        let impact = UIImpactFeedbackGenerator()
        
        impact.impactOccurred()
        
        if isSearching{
            
            if isFilteredInDonated || isFilteredInCurrentMonth{
                if  searchedfilterdFish[index.section][index.row].get {
                    searchedfilterdFish[index.section][index.row].get = false
                }
                else{
                    searchedfilterdFish[index.section][index.row].get = true
                }
                updateSearchResults(for: searchController)
            }
            else{
                if searchedFish[index.row].get {
                    searchedFish[index.row].get = false
                }
                else{
                    searchedFish[index.row].get = true
                }
            }
            
            
        }
        else{
            
            if isFilteredInDonated || isFilteredInCurrentMonth{
                if  filterdFish[index.section][index.row].get {
                    filterdFish[index.section][index.row].get = false
                }
                else{
                    filterdFish[index.section][index.row].get = true
                }
            }
            else{
                if fishes[index.row].get {
                    fishes[index.row].get = false
                }
                else{
                    fishes[index.row].get = true
                }
            }
        }
        save(fish: fishes)
        updateArray()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("button tapped at index:\(index)")
        
    }
    
}
