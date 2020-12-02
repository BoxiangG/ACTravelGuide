//
//  MoreTableViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/12/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    @IBOutlet weak var NSLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var PrivacyLabel: UILabel!
    @IBOutlet weak var TSLabel: UILabel!
    @IBOutlet weak var AboutLabel: UILabel!
    @IBOutlet weak var ReactionLabel: UILabel!
    @IBOutlet weak var supportDevLabel: UILabel!
    @IBOutlet weak var rugWallLabel: UILabel!
    @IBOutlet weak var HemishereLabel: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    
    override func viewDidLoad() {
        ReactionLabel.text = "Reactions".localized()
        NSLabel.text = "南北半球".localized()
        langLabel.text = "语言".localized()
        supportDevLabel.text = "支持开发者".localized()
        //PrivacyLabel.text = "Privacy Statement".localized()
        //TSLabel.text = "Terms & Conditions".localized()
        AboutLabel.text = "About".localized()
        rugWallLabel.text = "Rugs & Wallpapers".localized()
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewDidLoad()
        title = "More".localized()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func awakeFromNib() {
        
        title = "More".localized()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        switch section {
        case 0:
            return "More".localized()
        case 1:
            return "Preferences".localized()
        case 2:
            return "Others".localized()
        default:
            
            return nil
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.bool(forKey: "NorthHemishere")){
            HemishereLabel.text = "North Hemisphere".localized()
        }
        else{
            HemishereLabel.text = "South Hemisphere".localized()
        }
        
        let language = UserDefaults.standard.string(forKey: "i18n_language")
        switch language {
        case "en":
            LanguageLabel.text = "English"
        case "zh":
            LanguageLabel.text = "中文(简)"
        default:
            LanguageLabel.text = "English"
        }
        
        
    }
    
    
}
