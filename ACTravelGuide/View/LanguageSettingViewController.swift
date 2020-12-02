//
//  LanguageSettingViewController.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 5/24/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit


class LanguageSetting: UITableViewController {
    // @IBAction func unwind(segue: UIStoryboardSegue){}
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            UserDefaults.standard.set("zh", forKey: "i18n_language")
        }
        else{
            UserDefaults.standard.set("en", forKey: "i18n_language")
        }
        print(UserDefaults.standard.string(forKey: "i18n_language")!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        //    if let viewController = storyboard?.instantiateViewController(identifier: "MoreTableViewController") as? MoreTableViewController {
        //        navigationController?.pushViewController(viewController, animated: true)
        //    }
        self.navigationController?.popToRootViewController(animated: true)
        
        //  let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CatalogTableViewController")
        //        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        //        rootviewcontroller.rootViewController = firstVC
        
    }
    
    
    
}



