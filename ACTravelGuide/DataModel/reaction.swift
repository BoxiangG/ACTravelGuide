//
//  reaction.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 6/1/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//


import UIKit
import RealmSwift

struct reactionItem: Codable{
    var name:String = ""
    var image:String  = ""
    var source:[String] = []
    var sourceNotes:String?
    var internalID: Int = 0
    var uniqueEntryID:String = ""
}

class reaction: Object{
    @objc dynamic var acquired:Bool = false
    @objc dynamic var favored:Bool = false
    @objc dynamic var name = ""
    @objc dynamic var nameCN = ""
    @objc dynamic var image = ""
    let source = List<String>()
    @objc dynamic var sourceNotes:String?
    @objc dynamic var uniqueEntryID:String = ""

    override static func primaryKey() -> String? {
        return "uniqueEntryID"
    }

   
}
//for decode reactions_multilanguage to get reaction in chinese
    struct locale:Codable{
        var USen = ""
        var EUen = ""
        var EUde = ""
        var EUes = ""
        var USes = ""
        var EUfr = ""
        var USfr = ""
        var EUit = ""
        var EUnl = ""
        var CNzh = ""
        var TWzh = ""
        var JPja = ""
        var KRko = ""
        var EUru = ""
    }
   
struct reactionMultiLanguage:Codable{
        var id:String = ""
        var version = ""
        var locale:locale
    }
