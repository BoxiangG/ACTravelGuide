//
//  FossilTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/25/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import RealmSwift


class FossilTableViewController: UITableViewController {
    //MARK: - Properties
    let realm = try! Realm()
    var fossils = Array(try! Realm().objects(fossil.self).sorted(byKeyPath: "internalID"))
    var filterdFossil: [[fossil]] = [[],[]]
    
    var searchedFossil: [fossil] = []
    var searchedFilterdFossil: [[fossil]] = [[],[]]
    var isFilteredInDonated:Bool = false
    let defaults = UserDefaults.standard
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    
    @IBAction func donatedButton(_ sender: Any) {
        
        if isFilteredInDonated{
            isFilteredInDonated = false
        }
        else{
            isFilteredInDonated = true
        }
        updateFilter()
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
        
        self.title = "Fossils".localized()
        if(isFilteredInDonated){
            
        }
        super.viewDidLoad()
        
        
        tableView.rowHeight = 128
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Fossils".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFilteredInDonated == false{
            return nil
        }
        else{
            if section == 0 {
                return "Not donated".localized()
            }
            else {
                return "Donated".localized()
            }
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFilteredInDonated {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if isFilteredInDonated{
                return searchedFilterdFossil[section].count
            }
            return searchedFossil.count
        }
        else{
            if isFilteredInDonated {
                return filterdFossil[section].count
            }
        }
        return fossils.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CritterTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CritterTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CritterTableViewCell.")
        }
        cell.delegate=self
        
        cell.indexPath = indexPath
        
        var thisfossil = fossils[indexPath.row]
        
        if isSearching{
            if isFilteredInDonated{
                thisfossil = searchedFilterdFossil[indexPath.section][indexPath.row]
                
            }
            else{
                thisfossil = searchedFossil[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated {
                thisfossil = filterdFossil[indexPath.section][indexPath.row]
            }
            else{
                thisfossil = fossils[indexPath.row]
            }
        }
        let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
            cell.nameLabel.text = "\(thisfossil.namezhCN)"//getLocalName(bugName: thisVillager.filename)
        }
        else{
            cell.nameLabel.text = "\(thisfossil.name)".capitalized//getLocalName(bugName: thisVillager.filename)
        }
        
        cell.priceLabel.text = "\(thisfossil.price)"
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.textAlignment = .left
        
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if  thisfossil.donated {
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
            
        }
        else{
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
        }
        
        cell.ImageLabel.kf.setImage(with: URL(string: thisfossil.image))
        return cell
    }
    
    
    func getLocalName(bugName : String) -> String{
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
                
                //local name output
                let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
                if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
                    let name_cn = name["name-CNzh"] as! String
                    result = name_cn
                }
                else{
                    let name_en = name["name-USen"] as! String
                    result = name_en.capitalized
                }
            }
            
        }
        catch {
            print("Failed to load: \(error.localizedDescription)")
        }
        return result
    }
    
    
    private func updateFilter(){
        
        if isFilteredInDonated
        {
            
            filterdFossil[0] = (Array(realm.objects(fossil.self).filter("donated == false")))
            filterdFossil[1] = (Array(realm.objects(fossil.self).filter("donated == true")))
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
        }
        else
        {
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle")
        }
        
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        
        let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
            if realm.objects(fossil.self).filter("namezhCN contains[c] %@",searchText).count < 1
            {}
            else{
                if isFilteredInDonated {
                    searchedFilterdFossil[0] = (Array(realm.objects(fossil.self).filter("namezhCN contains[c] %@ AND donated == %@",searchText,false)))
                    searchedFilterdFossil[1] = (Array(realm.objects(fossil.self).filter("namezhCN contains[c] %@ AND donated == %@",searchText,true)))
                }
                else{
                    searchedFossil = (Array(realm.objects(fossil.self).filter("namezhCN contains[c] %@",searchText)))
                }
            }
        }
        else{
            if realm.objects(fossil.self).filter("name contains[c] %@",searchText).count < 1
            {}
            else{
                if isFilteredInDonated {
                    searchedFilterdFossil[0] = (Array(realm.objects(fossil.self).filter("name contains[c] %@ AND donated == %@",searchText,false)))
                    searchedFilterdFossil[1] = (Array(realm.objects(fossil.self).filter("name contains[c] %@ AND donated == %@",searchText,true)))
                }
                else{
                    searchedFossil = (Array(realm.objects(fossil.self).filter("name contains[c] %@",searchText)))
                }
            }
        }
        
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
}

extension FossilTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


extension FossilTableViewController: CritterCellDelegate{
    func didTapFavButton(at index: IndexPath) {
        
    }
    
    func didTapgetButton(at index: IndexPath) {
        
        let impact = UIImpactFeedbackGenerator()
        
        impact.impactOccurred()
        
        
        if isSearching{
            
            if isFilteredInDonated {
                let internalID = searchedFilterdFossil[index.section][index.row].internalID
                updateStatus(internalID: internalID)
                updateSearchResults(for: searchController)
                
            }
            else{
                let internalID = searchedFossil[index.row].internalID
                updateStatus(internalID: internalID)
            }
            
        }
        else{
            
            if isFilteredInDonated {
                let internalID = filterdFossil[index.section][index.row].internalID
                updateStatus(internalID: internalID)
                updateFilter()
            }
            else{
                let internalID = fossils[index.row].internalID
                updateStatus(internalID: internalID)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("button tapped at index:\(index)")
        
    }
    
    private func updateStatus(internalID:Int){
        
        if realm.objects(fossil.self).filter("internalID == %@",internalID)[0].donated{
            try! realm.write {
                realm.create(fossil.self, value: ["internalID": internalID, "donated": false], update: .modified)
            }
        }else{
            try! realm.write {
                realm.create(fossil.self, value: ["internalID": internalID, "donated": true], update: .modified)
            }
        }
    }
}



