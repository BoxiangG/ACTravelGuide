//
//  Critter.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/5/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit


struct bugItem: Codable{
    var number:Int = 0
    var name:String = ""
    var iconImageUrl:String  = ""
    var critterpediaImageUrl:String = ""
    var furnitureImageUrl:String = ""
    var sellPrice:Int = 0
    var location:String = ""
    var weather:String = ""
    var rarity:String = ""
    var startTime:[String] = []
    var endTime:[String] = []
    var northernHemisphereMonths:[Bool] = []
    var southernHemisphereMonths:[Bool] = []
    var color1:String = ""
    var color2:String = ""
    var iconFilename:String = ""
    var critterpediaFilename:String = ""
    var furnitureFilename:String = ""
    var internalId:Int = 0
    var uniqueEntryId:String = ""
}
class bug: Codable{
    var get:Bool
    let bugData:bugItem
    
    
    //MARK: Initialization
    init(get:Bool,creature:bugItem){
        self.get = false
        self.bugData = creature
    }
}

