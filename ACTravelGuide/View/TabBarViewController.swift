//
//  TabBarViewController.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 5/26/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.items?[0].title = "Museum".localized()
        self.tabBarController?.tabBar.items?[1].title = "More".localized()
        self.viewControllers![0].title="Museum".localized()
        self.title = "Test"
        self.tabBarItem.title = "Test"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
