//
//  ArtTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/26/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

class ArtTableViewController: UITableViewController  {
    
    //MARK: - Properties
    var arts = [art]()
    
    var filterdArt: [[art]] = [[],[]]
    var searchedfilterdArt: [[art]] = [[],[]]
    var searchedArt: [art] = []
    
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
    
    
    @IBAction func caughtbutton(_ sender: Any) {
        if isFilteredInDonated
        {
            isFilteredInDonated = false
            updateFilter()
        }
        else
        {
            
            isFilteredInDonated = true
            self.updateFilter()
        }
    }
    
    override func viewDidLoad() {
        
        self.title = "Arts".localized()
        if(isFilteredInDonated){
            
        }
        super.viewDidLoad()
        
        load()
        
        tableView.rowHeight = 128
        // searchbar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Arts".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedArt:art
        if isSearching {
            if isFilteredInDonated {
                selectedArt = searchedfilterdArt[indexPath.section][indexPath.row]
            }
            else{
                selectedArt = searchedArt[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated {
                selectedArt = filterdArt[indexPath.section][indexPath.row]
            }
            else{
                selectedArt = arts[indexPath.row]
            }
            
        }
        
        if let viewController = storyboard?.instantiateViewController(identifier: "ArtDetailViewController") as? ArtDetailViewController {
            viewController.thisArt = selectedArt
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
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
                return searchedfilterdArt[section].count
            }
            return searchedArt.count
        }
        else{
            if isFilteredInDonated {
                return filterdArt[section].count
            }
        }
        return arts.count
        
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
        
        var thisart:art
        if isSearching {
            if isFilteredInDonated {
                thisart = searchedfilterdArt[indexPath.section][indexPath.row]
            }
            else{
                thisart = searchedArt[indexPath.row]
            }
        }
        else{
            if isFilteredInDonated {
                thisart = filterdArt[indexPath.section][indexPath.row]
            }
            else{
                thisart = arts[indexPath.row]
            }
            
        }
        
        cell.nameLabel.text = getLocalName(bugName: thisart.name)
        cell.realTitle.text = thisart.realArtworkTitle
        if thisart.hasFake {
            cell.artGenuineLabel.text = "有赝品".localized()
            
        }
        else{
            cell.artGenuineLabel.text = "总是真迹".localized()
            
        }
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if  thisart.donated {
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal.fill", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
            
        }
        else{
            cell.getButton.setImage(UIImage(systemName: "checkmark.seal", withConfiguration: smallConfiguration), for: .normal)
            cell.getButton.tintColor = .darkGray
        }
        
        //print(thisart.trueImage)
        cell.ImageLabel.kf.setImage(with: URL(string: thisart.trueImage))
        return cell
    }
    
    
    
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
    
    
    private func updateFilter(){
        if isFilteredInDonated
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
        self.filterdArt.removeAll()
        self.filterdArt.append([art]())
        self.filterdArt.append([art]())
        
        if isFilteredInDonated{
            for art in arts{
                if art.donated {
                    filterdArt[1].append(art)
                }
                else{
                    filterdArt[0].append(art)
                }
            }
        }
    }
    
    
    func save(art:[art]){
        do{
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("UserArtsData.json")
            try JSONEncoder().encode(art).write(to: fileURL)
        }
        catch{
            print(error)
        }
    }
    
    func load(){
        do{
            filterdArt.removeAll()
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("UserArtsData.json")
            let data = try Data(contentsOf: fileURL)
            let arts = try JSONDecoder().decode([art].self, from: data)
            //print(arts)
            self.arts = arts
            
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
        if isFilteredInDonated {
            
            for _ in filterdArt{
                searchedfilterdArt[index] = filterdArt[index].filter { (art: art) -> Bool in
                    return getLocalName(bugName: art.name).lowercased().contains(searchText.lowercased())
                }
                index += 1
            }
        }
        else{
            searchedArt = arts.filter { (art: art) -> Bool in
                return getLocalName(bugName: art.name).lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
}
extension ArtTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}



extension ArtTableViewController: CritterCellDelegate{
    func didTapFavButton(at index: IndexPath) {
        
    }
    
    
    func didTapgetButton(at index: IndexPath) {
        
        let impact = UIImpactFeedbackGenerator()
        
        impact.impactOccurred()
        
        if isSearching{
            
            if isFilteredInDonated {
                if  searchedfilterdArt[index.section][index.row].donated {
                    searchedfilterdArt[index.section][index.row].donated = false
                }
                else{
                    searchedfilterdArt[index.section][index.row].donated = true
                }
                updateArray()
                updateSearchResults(for: searchController)
            }
            else{
                if searchedArt[index.row].donated {
                    searchedArt[index.row].donated = false
                }
                else{
                    searchedArt[index.row].donated = true
                }
            }
            
            
        }
        else{
            
            if isFilteredInDonated {
                if  filterdArt[index.section][index.row].donated {
                    filterdArt[index.section][index.row].donated = false
                }
                else{
                    filterdArt[index.section][index.row].donated = true
                }
            }
            else{
                if arts[index.row].donated {
                    arts[index.row].donated = false
                }
                else{
                    arts[index.row].donated = true
                }
            }
        }
        save(art: arts)
        updateArray()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("button tapped at index:\(index)")
        
    }
    
    
}
