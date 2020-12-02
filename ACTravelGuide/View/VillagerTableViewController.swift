//
//  VillagerTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/29/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import RealmSwift

class VillagerTableViewController: UITableViewController {
    
    //MARK: - Properties
    let realm = try! Realm()
    var villagers = Array(try! Realm().objects(villager.self).sorted(byKeyPath: "name"))
    //.sorted(byKeyPath: "villager.filename")
   // var villagers = [villager]()
    var filteredVillager: [[villager]] = [[],[]]
    var searchedfilterdVillager: [[villager]] = [[],[]]
    var searchedVillager: [villager] = []
    
    var isFilteredInMarked:Bool = false
    var isFilteredInFavored:Bool = false
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBAction func tapSortButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "根据...排序".localized(), preferredStyle: .actionSheet)
                   
                   alert.addAction(UIAlertAction(title: "Birthday".localized(), style: .default , handler:{ (UIAlertAction)in
                    
                     var dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd"
                    
                    self.villagers = self.villagers.sorted(by: { dateFormatter.date(from: $0.birthday)?.compare((dateFormatter.date(from: $1.birthday))!) == .orderedAscending })
                    if self.isFilteredInMarked || self.isFilteredInFavored{
                        self.filteredVillager[0] = self.filteredVillager[0].sorted(by: { dateFormatter.date(from: $0.birthday)?.compare((dateFormatter.date(from: $1.birthday))!) == .orderedAscending  })
                        self.filteredVillager[1] = self.filteredVillager[1].sorted(by: { dateFormatter.date(from: $0.birthday)?.compare((dateFormatter.date(from: $1.birthday))!) == .orderedAscending })
                    }
                        self.tableView.reloadData()
                   }))
        
        alert.addAction(UIAlertAction(title: "Default".localized(), style: .default , handler:{ (UIAlertAction)in
            self.villagers = Array(try! Realm().objects(villager.self).sorted(byKeyPath: "name"))
            self.updateFilter()
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
            self.isFilteredInMarked = false
            self.isFilteredInFavored = false
            self.updateFilter()
        }))
        
        alert.addAction(UIAlertAction(title: "Resident".localized(), style: .default , handler:{ (UIAlertAction)in
            self.isFilteredInMarked = true
            self.isFilteredInFavored = false
            self.updateFilter()
        }))
        
        alert.addAction(UIAlertAction(title: "Favorite".localized(), style: .default , handler:{ (UIAlertAction)in
            self.isFilteredInMarked = false
            self.isFilteredInFavored = true
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
        //searchController.isActive = true
        
        self.title = "Villagers".localized()
        if(isFilteredInMarked || isFilteredInFavored){
            
        }
        super.viewDidLoad()
        updateFilter()
        //load()
        
        tableView.rowHeight = 60
        
        // searchbar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Villagers".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.tableView.reloadData()
        
    }
    override func awakeFromNib() {
         //viewDidLoad()
        title = "Villagers".localized()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
        self.tableView.reloadData()
        
    }
    
    //MARK: - Navigation
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedVillager:villager
        
        if isSearching {
            if isFilteredInMarked || isFilteredInFavored{
                selectedVillager = searchedfilterdVillager[indexPath.section][indexPath.row]
            }
            else{
                selectedVillager = searchedVillager[indexPath.row]
            }
        }
        else{
            if isFilteredInMarked || isFilteredInFavored{
                selectedVillager = filteredVillager[indexPath.section][indexPath.row]
            }
            else{
                selectedVillager = villagers[indexPath.row]
            }
        }
        
        if let viewController = storyboard?.instantiateViewController(identifier: "VillagerDetailViewController") as? VillagerDetailViewController {
            viewController.thisVillager = selectedVillager
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFilteredInMarked{
            if section == 0 {
                return "Not Resident".localized()
            }
            else {
                return "Resident".localized()
            }
            
        }else if isFilteredInFavored{
            if section == 0 {
                return "Favorite".localized()
            }
            else{
                return "Others".localized()
            }
        }
        return nil
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFilteredInMarked || isFilteredInFavored{
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            if isFilteredInMarked || isFilteredInFavored{
                return searchedfilterdVillager[section].count
            }
            return searchedVillager.count
        }
        else{
            if isFilteredInMarked || isFilteredInFavored{
                return filteredVillager[section].count
            }
        }
        return villagers.count
        
        
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
       // var thisVillager = villagers[indexPath.row]
        var thisVillager:villager
        
        if isSearching {
            if isFilteredInMarked || isFilteredInFavored{
                thisVillager = searchedfilterdVillager[indexPath.section][indexPath.row]
            }
            else{
                thisVillager = searchedVillager[indexPath.row]
            }
        }
        else{
            if isFilteredInMarked || isFilteredInFavored{
                thisVillager = filteredVillager[indexPath.section][indexPath.row]
            }
            else{
                thisVillager = villagers[indexPath.row]
            }
            
        }
        
        let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
            cell.nameLabel.text = thisVillager.nameCN
        }
        else{
            cell.nameLabel.text = thisVillager.name
        }
        
        cell.priceLabel.text = " \(thisVillager.birthday)"
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.textAlignment = .left
        cell.priceLabel.textAlignment = .left

        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if  thisVillager.marked {
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
            
        }
        else{
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
        }
        
        if  thisVillager.faved {
            cell.FavButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.FavButton.tintColor = .red
            
        }
        else{
            cell.FavButton.setImage(UIImage(systemName: "heart", withConfiguration: smallConfiguration), for: .normal)
            cell.FavButton.tintColor = .red
        }
        
        
        cell.ImageLabel.kf.setImage(with: URL(string: thisVillager.iconImage ))
        return cell
    }
    
    //MARK: private Methods
    
    private func updateFilter(){
         
        if isFilteredInMarked
        {
            filteredVillager[0] = (Array(realm.objects(villager.self).filter("marked == false").sorted(byKeyPath: "name")))
            filteredVillager[1] = (Array(realm.objects(villager.self).filter("marked == true").sorted(byKeyPath: "name")))
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
        }
        else if isFilteredInFavored
        {
            filteredVillager[1] = (Array(realm.objects(villager.self).filter("faved == false").sorted(byKeyPath: "name")))
            filteredVillager[0] = (Array(realm.objects(villager.self).filter("faved == true").sorted(byKeyPath: "name")))
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
        }
        else
        {
            villagers = Array(try! Realm().objects(villager.self).sorted(byKeyPath: "name"))
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle")
        }
        //updateArray()
        self.tableView.reloadData()
        
    }
    
    func filterContentForSearchText(_ searchText: String) {

        let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
            //LANGUAGE IS CN
            if realm.objects(villager.self).filter("nameCN contains[c] %@",searchText).count < 1
            {}
            else{
                if isFilteredInMarked {
                    searchedfilterdVillager[0] = (Array(realm.objects(villager.self).filter("nameCN contains[c] %@ AND marked == %@",searchText,false)))
                    searchedfilterdVillager[1] = (Array(realm.objects(villager.self).filter("nameCN contains[c] %@ AND marked == %@",searchText,true)))
                }
                if isFilteredInFavored {
                        searchedfilterdVillager[1] = (Array(realm.objects(villager.self).filter("nameCN contains[c] %@ AND faved == %@",searchText,false)))
                        searchedfilterdVillager[0] = (Array(realm.objects(villager.self).filter("nameCN contains[c] %@ AND faved == %@",searchText,true)))
                }
                else{
                    searchedVillager = (Array(realm.objects(villager.self).filter("nameCN contains[c] %@",searchText)))
                }
            }
        }
        else{
            if realm.objects(villager.self).filter("name contains[c] %@",searchText).count < 1
            {}
            else{
                if isFilteredInMarked {
                    searchedfilterdVillager[0] = (Array(realm.objects(villager.self).filter("name contains[c] %@ AND marked == %@",searchText,false)))
                    searchedfilterdVillager[1] = (Array(realm.objects(villager.self).filter("name contains[c] %@ AND marked == %@",searchText,true)))
                }
                if isFilteredInFavored {
                        searchedfilterdVillager[1] = (Array(realm.objects(villager.self).filter("name contains[c] %@ AND faved == %@",searchText,false)))
                        searchedfilterdVillager[0] = (Array(realm.objects(villager.self).filter("name contains[c] %@ AND faved == %@",searchText,true)))
                }
                else{
                    searchedVillager = (Array(realm.objects(villager.self).filter("name contains[c] %@",searchText)))
                }
            }
            
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}

extension VillagerTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension VillagerTableViewController: CritterCellDelegate{
    func didTapFavButton(at index: IndexPath) {
        let impact = UIImpactFeedbackGenerator()
               
               impact.impactOccurred()
               
               if isSearching{
                   
                   if isFilteredInMarked || isFilteredInFavored{
                       let filename = searchedfilterdVillager[index.section][index.row].filename
                           updateFavStatus(filename: filename)
                           updateSearchResults(for: searchController)
                       
                   }
                   else{
                       let filename = searchedVillager[index.row].filename
                       updateFavStatus(filename: filename)
                   }
               }
                   
               else{
                   
                   if isFilteredInMarked || isFilteredInFavored{
                       let filename = filteredVillager[index.section][index.row].filename
                       updateFavStatus(filename: filename)
                       updateSearchResults(for: searchController)
                       updateFilter()
                   }
                   else{
                      let filename = villagers[index.row].filename
                      updateFavStatus(filename: filename)
                   }
               }
               
               //save(villager: villagers)
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
            
    }
    
    
    func didTapgetButton(at index: IndexPath) {
        
        let impact = UIImpactFeedbackGenerator()
        
        impact.impactOccurred()
        
        if isSearching{
            
            if isFilteredInMarked || isFilteredInFavored{
                let filename = searchedfilterdVillager[index.section][index.row].filename
                    updateMarkStatus(filename: filename)
                    updateSearchResults(for: searchController)
                
            }
            else{
                let filename = searchedVillager[index.row].filename
                updateMarkStatus(filename: filename)
            }
        }
            
        else{
            
            if isFilteredInMarked || isFilteredInFavored{
                let filename = filteredVillager[index.section][index.row].filename
                updateMarkStatus(filename: filename)
                updateSearchResults(for: searchController)
                updateFilter()
            }
            else{
               let filename = villagers[index.row].filename
               updateMarkStatus(filename: filename)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
   
        
    }

    private func updateMarkStatus(filename:String){
        
        if realm.objects(villager.self).filter("filename == %@",filename)[0].marked{
            try! realm.write {
                realm.create(villager.self, value: ["filename": filename, "marked": false], update: .modified)
            }
        }else{
            try! realm.write {
                realm.create(villager.self, value: ["filename": filename, "marked": true], update: .modified)
            }
        }
        
    }
    
    private func updateFavStatus(filename:String){
        
        
        if realm.objects(villager.self).filter("filename == %@",filename)[0].faved{
            try! realm.write {
                realm.create(villager.self, value: ["filename": filename, "faved": false], update: .modified)
            }
        }else{
            try! realm.write {
                realm.create(villager.self, value: ["filename": filename, "faved": true], update: .modified)
            }
        }
        
    }
}


