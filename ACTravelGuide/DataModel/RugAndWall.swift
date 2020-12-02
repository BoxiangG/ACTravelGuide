//
//  RugAndWall.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 6/7/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct rugItem: Codable{
    var name:String = ""
    var image:String  = ""
    var diy:Bool = false
    var buy:Int = 0
    var sell:Int = 0
    var color1: String = ""
    var color2: String = ""
    var size: String = ""
    var milesPrice: Int = 0
    var source:[String] = []
    var sourceNotes:String?
    var version: String = ""
    var hhaConcept1: String = ""
    var hhaConcept2: String = ""
    var hhaSeries: String = ""
    var tag: String = ""
    var catalog: String = ""
    var filename: String = ""
    var internalID: Int = 0
    var uniqueEntryID: String = ""

}

struct wallPaperItem: Codable{
    var name:String = ""
    var image:String  = ""
    var vfx: Bool = false
    var vfxType: String  = ""
    var diy:Bool = false
    var buy:Int = 0
    var sell:Int = 0
    var color1: String = ""
    var color2: String = ""
    var milesPrice: Int = 0
    var source:[String] = []
    var sourceNotes:String?
    var catalog: String = ""
    var windowType: String = ""
    var windowColor: String = ""
    var paneType: String = ""
    var curtainType: String = ""
    var curtainColor: String = ""
    var ceilingType: String = ""
    var hhaConcept1: String = ""
    var hhaConcept2: String = ""
    var hhaSeries: String = ""
    var tag: String = ""
    var version: String = ""
    var filename: String = ""
    var internalID: Int = 0
    var uniqueEntryID: String = ""
}


class RugAndWall: Object{
    @objc dynamic var cataloged:Bool = false
    @objc dynamic var favored:Bool = false
    @objc dynamic var sell:Int = 0
    @objc dynamic var name = ""
    @objc dynamic var nameCN = ""
    @objc dynamic var image = ""
    @objc dynamic var size: String? = nil
    @objc dynamic var tag: String = ""
    let source = List<String>()
    @objc dynamic var hhaSeries: String? 
    @objc dynamic var sourceNotes:String?
    @objc dynamic var uniqueEntryID:String = ""
    @objc dynamic var catalog:String = ""
    override static func primaryKey() -> String? {
        return "uniqueEntryID"
    }

   
}
//for decode reactions_multilanguage to get reaction in chinese
struct rugMultiLanguage:Codable{
        var id:String = ""
        var version = ""
        var locale:locale
    }
