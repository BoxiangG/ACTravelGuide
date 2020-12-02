//
//  ReactionTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 6/1/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class ReactionTableViewController: UITableViewController {
    var isChinese = false
    //MARK: - Properties
    let realm = try! Realm()
    let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
    var reactions = Array(try! Realm().objects(reaction.self))
    var filterdReaction: [[reaction]] = [[],[]]
    
    var searchedReaction: [reaction] = []
    var searchedFilterdReaction: [[reaction]] = [[],[]]
    var isFilteredInAcquired:Bool = false
    var isFilteredInFavored:Bool = false
    
    let defaults = UserDefaults.standard
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    
    @IBAction func filterButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "根据...分组".localized(), preferredStyle: .actionSheet)
          
        alert.addAction(UIAlertAction(title: "不分组".localized(), style: .default , handler:{ (UIAlertAction)in
              self.isFilteredInAcquired = false
              self.isFilteredInFavored = false
              self.updateFilter()
          }))
          
        alert.addAction(UIAlertAction(title: "Acquired".localized(), style: .default , handler:{ (UIAlertAction)in
              self.isFilteredInAcquired = true
              self.isFilteredInFavored = false
              self.updateFilter()
          }))
          
        alert.addAction(UIAlertAction(title: "Favorite".localized(), style: .default , handler:{ (UIAlertAction)in
              self.isFilteredInAcquired = false
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
        
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
            isChinese = true
        }
        super.viewDidLoad()
        self.title = "Reactions".localized()
        
        tableView.rowHeight = 60
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Reactions".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedReaction:reaction
        
        if isSearching {
            if isFilteredInAcquired || isFilteredInFavored{
                selectedReaction = searchedFilterdReaction[indexPath.section][indexPath.row]
            }
            else{
                selectedReaction = searchedReaction[indexPath.row]
            }
        }
        else{
            if isFilteredInAcquired || isFilteredInFavored{
                selectedReaction = filterdReaction[indexPath.section][indexPath.row]
            }
            else{
                selectedReaction = reactions[indexPath.row]
            }
        }
        
        if let viewController = storyboard?.instantiateViewController(identifier: "ReactionDetailViewController") as? ReactionDetailViewController {
            viewController.thisReaction = selectedReaction
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        
        if isFilteredInAcquired{
            if section == 0 {
                return "Not acquired".localized()
            }
            else {
                return "Acquired".localized()
            }
        }
        else if isFilteredInFavored{
            if section == 0 {
                return "Favorite".localized()
            }
            else {
                return "Others".localized()
            }
        }
        return nil
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFilteredInAcquired || isFilteredInFavored {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if isFilteredInAcquired || isFilteredInFavored{
                return searchedFilterdReaction[section].count
            }
            return searchedReaction.count
        }
        else{
            if isFilteredInAcquired || isFilteredInFavored {
                return filterdReaction[section].count
            }
        }
        return reactions.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CritterTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CritterTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CritterTableViewCell.")
        }
        cell.delegate=self
        cell.accessoryType = .disclosureIndicator

        cell.indexPath = indexPath
        
        var thisReaction = reactions[indexPath.row]
        
        if isSearching{
            if isFilteredInAcquired || isFilteredInFavored{
                thisReaction = searchedFilterdReaction[indexPath.section][indexPath.row]
                
            }
            else{
                thisReaction = searchedReaction[indexPath.row]
            }
        }
        else{
            if isFilteredInAcquired || isFilteredInFavored {
                thisReaction = filterdReaction[indexPath.section][indexPath.row]
            }
            else{
                thisReaction = reactions[indexPath.row]
            }
        }
        if  isChinese {
            cell.nameLabel.text = thisReaction.nameCN
        }
        else{
            cell.nameLabel.text = thisReaction.name
            
        }
        cell.priceLabel.text = thisReaction.source[0].localized()
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.textAlignment = .left
        
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if  thisReaction.acquired {
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
            
        }
        else{
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
        }
        
        
        if  thisReaction.favored {
            cell.FavButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.FavButton.tintColor = .red
            
        }
        else{
            cell.FavButton.setImage(UIImage(systemName: "heart", withConfiguration: smallConfiguration), for: .normal)
            cell.FavButton.tintColor = .red
        }
        
        
        cell.ImageLabel.kf.setImage(with: URL(string: thisReaction.image))
        return cell
    }
    
    
    
    private func updateFilter(){
        
        if isFilteredInAcquired
        {
            filterdReaction[0] = (Array(realm.objects(reaction.self).filter("acquired == false")))
            filterdReaction[1] = (Array(realm.objects(reaction.self).filter("acquired == true")))
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
        }
        else if  isFilteredInFavored{
            filterdReaction[0] = (Array(realm.objects(reaction.self).filter("favored == false")))
            filterdReaction[1] = (Array(realm.objects(reaction.self).filter("favored == true")))
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
        }
        else
        {
            filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle")
        }
        self.tableView.reloadData()
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        if isChinese {
            if isFilteredInAcquired {
                searchedFilterdReaction[0] = (Array(realm.objects(reaction.self).filter("nameCN contains[c] %@ AND acquired == %@",searchText,false)))
                searchedFilterdReaction[1] = (Array(realm.objects(reaction.self).filter("nameCN contains[c] %@ AND acquired == %@",searchText,true)))
            }
            
            if isFilteredInFavored {
                    searchedFilterdReaction[0] = (Array(realm.objects(reaction.self).filter("nameCN contains[c] %@ AND favored == %@",searchText,false)))
                    searchedFilterdReaction[1] = (Array(realm.objects(reaction.self).filter("nameCN contains[c] %@ AND favored == %@",searchText,true)))
            }
            else{
                searchedReaction = (Array(realm.objects(reaction.self).filter("nameCN contains[c] %@",searchText)))
            }
            
        }
        if realm.objects(reaction.self).filter("name contains[c] %@",searchText).count < 1
        {}
        else{
            if isFilteredInAcquired {
                searchedFilterdReaction[0] = (Array(realm.objects(reaction.self).filter("name contains[c] %@ AND acquired == %@",searchText,false)))
                searchedFilterdReaction[1] = (Array(realm.objects(reaction.self).filter("name contains[c] %@ AND acquired == %@",searchText,true)))
            }
            if isFilteredInFavored {
                        searchedFilterdReaction[0] = (Array(realm.objects(reaction.self).filter("name contains[c] %@ AND favored == %@",searchText,false)))
                        searchedFilterdReaction[1] = (Array(realm.objects(reaction.self).filter("name contains[c] %@ AND favored == %@",searchText,true)))
            }
            else{
                searchedReaction = (Array(realm.objects(reaction.self).filter("name contains[c] %@",searchText)))
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
}

extension ReactionTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


extension ReactionTableViewController: CritterCellDelegate{
    func didTapFavButton(at index: IndexPath) {
        getUEID(at: index,button: "fav")
    }
    
    func didTapgetButton(at index: IndexPath) {
        getUEID(at: index, button: "acq")
        
    }
    private func getUEID(at index: IndexPath, button: String){
        
        let impact = UIImpactFeedbackGenerator()
        
        impact.impactOccurred()
        
        
        if isSearching{
            
            if isFilteredInAcquired {
                let uniqueEntryID = searchedFilterdReaction[index.section][index.row].uniqueEntryID
                if button == "acq"{
                    updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                else{
                    updateFavStatus(uniqueEntryID: uniqueEntryID)}
                
                updateSearchResults(for: searchController)
                
            }
            else{
                let uniqueEntryID = searchedReaction[index.row].uniqueEntryID
                if button == "acq"{
                    updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                else{
                    updateFavStatus(uniqueEntryID: uniqueEntryID)}
                
            }
            //updateSearchResults(for: searchController)
        }
        else{
            
            if isFilteredInAcquired {
                let uniqueEntryID = filterdReaction[index.section][index.row].uniqueEntryID
                if button == "acq"{
                    updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                else{
                    updateFavStatus(uniqueEntryID: uniqueEntryID)}
                
                updateFilter()
            }
            else{
                let uniqueEntryID = reactions[index.row].uniqueEntryID
                if button == "acq"{
                    updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                else{
                    updateFavStatus(uniqueEntryID: uniqueEntryID)}
                updateFilter()
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    private func updateAcqStatus(uniqueEntryID:String){
        
        if realm.objects(reaction.self).filter("uniqueEntryID == %@",uniqueEntryID)[0].acquired{
            try! realm.write {
                realm.create(reaction.self, value: ["uniqueEntryID": uniqueEntryID, "acquired": false], update: .modified)
                print("update s")
            }
        }else{
            try! realm.write {
                realm.create(reaction.self, value: ["uniqueEntryID": uniqueEntryID, "acquired": true], update: .modified)
                print("update sd")
                
            }
        }
    }
    private func updateFavStatus(uniqueEntryID:String){
        
        
        if realm.objects(reaction.self).filter("uniqueEntryID == %@",uniqueEntryID)[0].favored{
            try! realm.write {
                realm.create(reaction.self, value: ["uniqueEntryID": uniqueEntryID, "favored": false], update: .modified)
            }
        }else{
            try! realm.write {
                realm.create(reaction.self, value: ["uniqueEntryID": uniqueEntryID, "favored": true], update: .modified)
            }
        }
        
    }
}



