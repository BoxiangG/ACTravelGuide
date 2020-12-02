//
//  BugTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 4/12/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

class BugTableViewController: UITableViewController {
    
    //MARK: - Properties
    var bugs = [bug]()
    var filteredBug = [[bug]]()
    var searchedfilterdBug: [[bug]] = [[],[]]
    var searchedBug: [bug] = []
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
    @IBAction func tapedSort(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "根据...排序".localized(), preferredStyle: .actionSheet)
               
               alert.addAction(UIAlertAction(title: "Price".localized(), style: .default , handler:{ (UIAlertAction)in
                self.bugs = self.bugs.sorted(by: { $0.bugData.sellPrice > $1.bugData.sellPrice })
                if self.isFilteredInDonated || self.isFilteredInCurrentMonth{
                    self.filteredBug[0] = self.filteredBug[0].sorted(by: { $0.bugData.sellPrice > $1.bugData.sellPrice })
                    self.filteredBug[1] = self.filteredBug[1].sorted(by: { $0.bugData.sellPrice > $1.bugData.sellPrice })
                }
                    self.tableView.reloadData()
               }))
        
            alert.addAction(UIAlertAction(title: "Name".localized(), style: .default , handler:{ (UIAlertAction)in
                self.bugs = self.bugs.sorted(by: { self.initialChar(self.getLocalName(bugName: $0.bugData.name)).capitalized < self.initialChar(self.getLocalName(bugName: $1.bugData.name)).capitalized })
                if self.isFilteredInDonated || self.isFilteredInCurrentMonth{
                    self.filteredBug[0] = self.filteredBug[0].sorted(by: { self.initialChar(self.getLocalName(bugName: $0.bugData.name)) < self.initialChar(self.getLocalName(bugName: $1.bugData.name)) })
                    self.filteredBug[1] = self.filteredBug[1].sorted(by: { self.initialChar(self.getLocalName(bugName: $0.bugData.name)) < self.initialChar(self.getLocalName(bugName: $1.bugData.name)) })
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
    
    @IBAction func caughtbutton(_ sender: Any) {
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
        
        sortButton.image = UIImage(systemName:"arrow.up.arrow.down.circle")
        self.title = "Bugs".localized()
        if(isFilteredInDonated){
            
        }
        super.viewDidLoad()
        load()
        
        tableView.rowHeight = 60
        // searchbar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Bugs".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        load()
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
        var selectedBug:bug
        if isSearching {
            if isFilteredInDonated || isFilteredInCurrentMonth{
                selectedBug = searchedfilterdBug[indexPath.section][indexPath.row]
            }
            else{
                selectedBug = searchedBug[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated || isFilteredInCurrentMonth{
                selectedBug = filteredBug[indexPath.section][indexPath.row]
            }
            else{
                selectedBug = bugs[indexPath.row]
            }
            
        }
        
        if let viewController = storyboard?.instantiateViewController(identifier: "BugsDetailViewController") as? BugsDetailViewController {
            viewController.thisBug = selectedBug
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
                return searchedfilterdBug[section].count
            }
            return searchedBug.count
        }
        else{
            if isFilteredInDonated || isFilteredInCurrentMonth{
                return filteredBug[section].count
            }
        }
        return bugs.count
        
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
        var thisbug:bug
        
        if isSearching {
            if isFilteredInDonated || isFilteredInCurrentMonth{
                thisbug = searchedfilterdBug[indexPath.section][indexPath.row]
            }
            else{
                thisbug = searchedBug[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated || isFilteredInCurrentMonth{
                thisbug = filteredBug[indexPath.section][indexPath.row]
            }
            else{
                thisbug = bugs[indexPath.row]
            }
            
        }
        
        cell.nameLabel.text = getLocalName(bugName: thisbug.bugData.name).capitalized
        //cell.nameLabel.text = thisbug.bugData.name.
        
        
        //need fix alignment
        cell.priceLabel.text = "\(thisbug.bugData.sellPrice)"
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.textAlignment = .left
        
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if  thisbug.get {
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
            
        }
        else{
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
        }
        
        
        
        //print(thisbug.bugData.iconImageUrl)
        cell.ImageLabel.kf.setImage(with: URL(string: thisbug.bugData.iconImageUrl))
        return cell
    }
    
    //MARK: private Methods
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
        self.filteredBug.removeAll()
        self.filteredBug.append([bug]())
        self.filteredBug.append([bug]())
        
        if isFilteredInDonated{
            for bug in bugs{
                if bug.get {
                    filteredBug[1].append(bug)
                }
                else{
                    filteredBug[0].append(bug)
                }
            }
        }else if isFilteredInCurrentMonth{
            let currentDate = Date()
            let index = Calendar.current.component(.month, from: currentDate)
            if UserDefaults.standard.bool(forKey: "NorthHemishere"){
                for bug in bugs{
                    if bug.bugData.northernHemisphereMonths[index-1] {
                        filteredBug[0].append(bug)
                    }
                    else{
                        filteredBug[1].append(bug)
                    }
                }
                
            }
            else{
                for bug in bugs{
                    if bug.bugData.southernHemisphereMonths[index-1] {
                        filteredBug[0].append(bug)
                        
                    }
                    else{
                        filteredBug[1].append(bug)
                    }
                }
            }
            
            
        }
    }
    func save(bug:[bug]){
        
        do{
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("UserBugsData.json")
            try JSONEncoder().encode(bug).write(to: fileURL)
        }
        catch{
            print(error)
        }
    }
    
    func load(){
        do{
            filteredBug.removeAll()
            bugs.removeAll()
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("UserBugsData.json")
            let data = try Data(contentsOf: fileURL)
            let bugs = try JSONDecoder().decode([bug].self, from: data)
            //print(bugs)
            self.bugs = bugs
            
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
            
            for _ in filteredBug{
                searchedfilterdBug[index] = filteredBug[index].filter { (bug: bug) -> Bool in
                    return getLocalName(bugName: bug.bugData.name).lowercased().contains(searchText.lowercased())
                }
                index += 1
            }
        }
        else{
            searchedBug = bugs.filter { (bug: bug) -> Bool in
                return getLocalName(bugName: bug.bugData.name).lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
//    func transformToPinyin(hasBlank: Bool = false) -> String {
//
//        let stringRef = NSMutableString(string: self)
//        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
//        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
//        let pinyin = stringRef as String
//        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
//    }
    
    func initialChar(_ chineseString:String) -> String {
        let temp:CFMutableString = CFStringCreateMutableCopy(nil, 0, chineseString as CFString);
        CFStringTransform(temp, nil, kCFStringTransformToLatin, false)
        CFStringTransform(temp, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = temp as String
        guard let result = CFStringCreateWithSubstring(nil, temp, CFRangeMake(0, 1)) else { return ""}
        return pinyin as String
    }
    
    
}

extension BugTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}




extension BugTableViewController: CritterCellDelegate{
    func didTapFavButton(at index: IndexPath) {
        
    }
    
    
    func didTapgetButton(at index: IndexPath) {
        
        let impact = UIImpactFeedbackGenerator()
        
        impact.impactOccurred()
        
        if isSearching{
            
            if isFilteredInDonated || isFilteredInCurrentMonth{
                if  searchedfilterdBug[index.section][index.row].get {
                    searchedfilterdBug[index.section][index.row].get = false
                }
                else{
                    searchedfilterdBug[index.section][index.row].get = true
                }
                updateArray()
                updateSearchResults(for: searchController)
            }
            else{
                if searchedBug[index.row].get {
                    searchedBug[index.row].get = false
                }
                else{
                    searchedBug[index.row].get = true
                }
            }
            
            
        }
        else{
            
            if isFilteredInDonated || isFilteredInCurrentMonth{
                if  filteredBug[index.section][index.row].get {
                    filteredBug[index.section][index.row].get = false
                }
                else{
                    filteredBug[index.section][index.row].get = true
                }
            }
            else{
                if bugs[index.row].get {
                    bugs[index.row].get = false
                }
                else{
                    bugs[index.row].get = true
                }
            }
        }
        save(bug: bugs)
        updateArray()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("button tapped at index:\(index)")
        
    }
    
    
}



