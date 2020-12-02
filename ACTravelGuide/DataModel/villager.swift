//
//  villager.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/29/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//


import UIKit
import RealmSwift


struct villagerItem: Codable{
    var name:String = ""
    var iconImage:String  = ""
    var houseImage:String  = ""
    var species:String  = ""
    var gender:String  = ""
    var personality:String  = ""
    var hobby:String  = ""
    var birthday:String  = ""
    var catchphrase:String = ""
    var favoriteSong:String = ""
    var style1:String = ""
    var style2:String = ""
    var color1:String = ""
    var color2:String = ""
    var wallpaper:String = ""
    var flooring:String = ""
    var furnitureList:[String]
    var filename:String = ""
    var uniqueEntryID:String = ""
}

class villager: Object{
    @objc dynamic var nameCN:String = ""
    @objc dynamic var marked:Bool = false
    @objc dynamic var faved:Bool = false
    
    @objc dynamic var name = ""
    @objc dynamic var iconImage = ""
    @objc dynamic var houseImage = ""
    @objc dynamic var species = ""
    @objc dynamic var gender = ""
    @objc dynamic var personality = ""
    @objc dynamic var hobby = ""
    @objc dynamic var birthday = ""
    @objc dynamic var phrase = ""
    @objc dynamic var favoriteSong = ""
    @objc dynamic var style1 = ""
    @objc dynamic var style2 = ""
    @objc dynamic var color1 = ""
    @objc dynamic var color2 = ""
    @objc dynamic var wallpaper = ""
    @objc dynamic var flooring = ""
    dynamic var furnitureList = List<String>()
    @objc dynamic var filename = ""
    @objc dynamic var uniqueEntryID = ""
    //@objc dynamic var flooring = ""
    
    
    override static func primaryKey() -> String? {
        return "filename"
    }

}
