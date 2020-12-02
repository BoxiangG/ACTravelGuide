//
//  Fish.swift
//  ACTravelGuide
//
//  Created by Shaohang Hu on 5/15/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//


import UIKit


struct fishItem: Codable{
    var number:Int = 0
    var name:String = ""
    var iconImageUrl:String  = ""
    var critterpediaImageUrl:String = ""
    var furnitureImageUrl:String = ""
    var sellPrice:Int = 0
    var location:String = ""
    var shadow:String = ""
    var rarity:String = ""
    var rainSnowOnly:Bool = false
    var startTime:[String] = []
    var endTime:[String] = []
    var northernHemisphereMonths:[Bool] = []
    var southernHemisphereMonths:[Bool] = []
    var color1:String = ""
    var color2:String = ""
    var size:String = ""
    var lightingType:String=""
    
    var iconFileName:String = ""
    var critterpediaFilename:String = ""
    var furnitureFilename:String = ""
    var internalId:Int = 0
    var uniqueEntryId:String = ""
}
class fish: Codable{
    var get:Bool
    let fishData:fishItem
    
    
    //MARK: Initialization
    init(get:Bool,creature:fishItem){
        self.get = false
        self.fishData = creature
    }
}
