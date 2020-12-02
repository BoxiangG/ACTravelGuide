//
//  RugAndWallTableTableViewController.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 6/8/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift


class RugAndWallTableTableViewController: UITableViewController {

    var isChinese = false
    let realm = try! Realm()
    let cnLanguageCode = Set<String>(arrayLiteral:"zh-Hans", "zh-Hant","zh")
    var Items = Array(try! Realm().objects(RugAndWall.self))
    var filterdItem: [[RugAndWall]] = [[],[]]
    var searchedItem: [RugAndWall] = []
    var searchedFilterdItem: [[RugAndWall]] = [[],[]]
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
    @IBAction func tapFilterButton(_ sender: Any) {
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
        super.viewDidLoad()
        if(cnLanguageCode.contains(UserDefaults.standard.string(forKey: "i18n_language")!)){
                  isChinese = true
              }
              //super.viewDidLoad()
              self.title = "Rugs & Wallpapers".localized()
              
              tableView.rowHeight = 60
              
              searchController.searchResultsUpdater = self
              searchController.obscuresBackgroundDuringPresentation = false
              searchController.searchBar.placeholder = "Search Rug or Wallpaper".localized()
              navigationItem.searchController = searchController
              definesPresentationContext = true

     
    }
     
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var selectedReaction:RugAndWall
            
            if isSearching {
                if isFilteredInAcquired || isFilteredInFavored{
                    selectedReaction = searchedFilterdItem[indexPath.section][indexPath.row]
                }
                else{
                    selectedReaction = searchedItem[indexPath.row]
                }
            }
            else{
                if isFilteredInAcquired || isFilteredInFavored{
                    selectedReaction = filterdItem[indexPath.section][indexPath.row]
                }
                else{
                    selectedReaction = Items[indexPath.row]
                }
            }
            
            if let viewController = storyboard?.instantiateViewController(identifier: "RugAndWallDetailViewController") as? RugAndWallDetailViewController {
                viewController.thisItem = selectedReaction
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
                    return searchedFilterdItem[section].count
                }
                return searchedItem.count
            }
            else{
                if isFilteredInAcquired || isFilteredInFavored {
                    return filterdItem[section].count
                }
            }
            return Items.count
            
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellIdentifier = "CritterTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CritterTableViewCell  else {
                fatalError("The dequeued cell is not an instance of CritterTableViewCell.")
            }
            cell.delegate=self
            cell.accessoryType = .disclosureIndicator
            cell.indexPath = indexPath
            
            var thisItem = Items[indexPath.row]
            
            if isSearching{
                if isFilteredInAcquired || isFilteredInFavored{
                    thisItem = searchedFilterdItem[indexPath.section][indexPath.row]
                    
                }
                else{
                    thisItem = searchedItem[indexPath.row]
                }
            }
            else{
                if isFilteredInAcquired || isFilteredInFavored {
                    thisItem = filterdItem[indexPath.section][indexPath.row]
                }
                else{
                    thisItem = Items[indexPath.row]
                }
            }
            if  isChinese {
                cell.nameLabel.text = thisItem.nameCN
            }
            else{
                cell.nameLabel.text = thisItem.name.capitalized
                
            }
            if(thisItem.catalog == "For sale"){
                cell.priceLabel.text = "\(thisItem.sell )"
            }
            else{
                cell.priceLabel.text = thisItem.catalog.localized()
            }
            
            cell.priceLabel.numberOfLines = 0
            cell.priceLabel.textAlignment = .left
            
            
            let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
            if  thisItem.cataloged {
                cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
                cell.getButton.tintColor = .darkGray
                
            }
            else{
                cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
                cell.getButton.tintColor = .darkGray
            }
            
            
            if  thisItem.favored {
                cell.FavButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: smallConfiguration), for: .normal)
                cell.FavButton.tintColor = .red
                
            }
            else{
                cell.FavButton.setImage(UIImage(systemName: "heart", withConfiguration: smallConfiguration), for: .normal)
                cell.FavButton.tintColor = .red
            }
            
            
            cell.ImageLabel.kf.setImage(with: URL(string: thisItem.image))
            return cell
        }
        
        
        
        private func updateFilter(){
            
            if isFilteredInAcquired
            {
                filterdItem[0] = (Array(realm.objects(RugAndWall.self).filter("cataloged == false")))
                filterdItem[1] = (Array(realm.objects(RugAndWall.self).filter("cataloged == true")))
                filterButton.image = UIImage(systemName:"line.horizontal.3.decrease.circle.fill")
            }
            else if  isFilteredInFavored{
                filterdItem[0] = (Array(realm.objects(RugAndWall.self).filter("favored == false")))
                filterdItem[1] = (Array(realm.objects(RugAndWall.self).filter("favored == true")))
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
                    searchedFilterdItem[0] = (Array(realm.objects(RugAndWall.self).filter("nameCN contains[c] %@ AND cataloged == %@",searchText,false)))
                    searchedFilterdItem[1] = (Array(realm.objects(RugAndWall.self).filter("nameCN contains[c] %@ AND cataloged == %@",searchText,true)))
                }
                
                if isFilteredInFavored {
                        searchedFilterdItem[0] = (Array(realm.objects(RugAndWall.self).filter("nameCN contains[c] %@ AND favored == %@",searchText,false)))
                        searchedFilterdItem[1] = (Array(realm.objects(RugAndWall.self).filter("nameCN contains[c] %@ AND favored == %@",searchText,true)))
                }
                else{
                    searchedItem = (Array(realm.objects(RugAndWall.self).filter("nameCN contains[c] %@",searchText)))
                }
                
            }
            if realm.objects(RugAndWall.self).filter("name contains[c] %@",searchText).count < 1
            {}
            else{
                if isFilteredInAcquired {
                    searchedFilterdItem[0] = (Array(realm.objects(RugAndWall.self).filter("name contains[c] %@ AND cataloged == %@",searchText,false)))
                    searchedFilterdItem[1] = (Array(realm.objects(RugAndWall.self).filter("name contains[c] %@ AND cataloged == %@",searchText,true)))
                }
                if isFilteredInFavored {
                            searchedFilterdItem[0] = (Array(realm.objects(RugAndWall.self).filter("name contains[c] %@ AND favored == %@",searchText,false)))
                            searchedFilterdItem[1] = (Array(realm.objects(RugAndWall.self).filter("name contains[c] %@ AND favored == %@",searchText,true)))
                }
                else{
                    searchedItem = (Array(realm.objects(RugAndWall.self).filter("name contains[c] %@",searchText)))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        
    }

    extension RugAndWallTableTableViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            filterContentForSearchText(searchBar.text!)
        }
    }


    extension RugAndWallTableTableViewController: CritterCellDelegate{
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
                    let uniqueEntryID = searchedFilterdItem[index.section][index.row].uniqueEntryID
                    if button == "acq"{
                        updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                    else{
                        updateFavStatus(uniqueEntryID: uniqueEntryID)}
                    
                    updateSearchResults(for: searchController)
                    
                }
                else{
                    let uniqueEntryID = searchedItem[index.row].uniqueEntryID
                    if button == "acq"{
                        updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                    else{
                        updateFavStatus(uniqueEntryID: uniqueEntryID)}
                    
                }
                //updateSearchResults(for: searchController)
            }
            else{
                
                if isFilteredInAcquired {
                    let uniqueEntryID = filterdItem[index.section][index.row].uniqueEntryID
                    if button == "acq"{
                        updateAcqStatus(uniqueEntryID: uniqueEntryID)}
                    else{
                        updateFavStatus(uniqueEntryID: uniqueEntryID)}
                    
                    updateFilter()
                }
                else{
                    let uniqueEntryID = Items[index.row].uniqueEntryID
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
            
            if realm.objects(RugAndWall.self).filter("uniqueEntryID == %@",uniqueEntryID)[0].cataloged{
                try! realm.write {
                    realm.create(RugAndWall.self, value: ["uniqueEntryID": uniqueEntryID, "cataloged": false], update: .modified)
                    print("update s")
                }
            }else{
                try! realm.write {
                    realm.create(RugAndWall.self, value: ["uniqueEntryID": uniqueEntryID, "cataloged": true], update: .modified)
                    print("update sd")
                    
                }
            }
        }
        private func updateFavStatus(uniqueEntryID:String){
            
            
            if realm.objects(RugAndWall.self).filter("uniqueEntryID == %@",uniqueEntryID)[0].favored{
                try! realm.write {
                    realm.create(RugAndWall.self, value: ["uniqueEntryID": uniqueEntryID, "favored": false], update: .modified)
                }
            }else{
                try! realm.write {
                    realm.create(RugAndWall.self, value: ["uniqueEntryID": uniqueEntryID, "favored": true], update: .modified)
                }
            }
            
        }
    }



