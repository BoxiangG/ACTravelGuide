//
//  Fossil.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/24/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import RealmSwift


struct fossilItem: Codable{
    var name:String = ""
    var image:String  = ""
    var buy:Int = 0
    var sell:Int = 0
    var color1:String = ""
    var color2:String = ""
    var size:String = ""
    var source:[String]
    var museum:String = ""
    var version:String = ""
    var interact:Bool
    var catalog:String = ""
    var filename:String = ""
    var internalID: Int = 0
    var uniqueEntryID:String = ""
}

class fossil: Object{
    @objc dynamic var namezhCN:String = ""
    @objc dynamic var donated:Bool = false
    @objc dynamic var name = ""
    @objc dynamic var price = 0
    @objc dynamic var image:String  = ""
    @objc dynamic var internalID  = 0
   

    override static func primaryKey() -> String? {
        return "internalID"
    }

}
