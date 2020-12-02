//
//  art.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/25/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//


import UIKit


struct artItem: Codable{
    var name:String = ""
    var image:String  = ""
    var highResTexture:String?
    var genuine:Bool = false
    var category:String = ""
    var buy:Int = 0
    var sell:Int = 0
    var color1:String = ""
    var color2:String = ""
    var size:String = ""
    var realArtworkTitle:String = ""
    var artist:String = ""
    var museumDescription:String = ""
    var source:[String]
    var version:String = ""
    var hhaConcept1:String = ""
    var hhaConcept2:String = ""
    var hhaSeries:String = ""
    var hhaSet:String = ""
    var interact:Bool
    var tag:String = ""
    var speakerType:String = ""
    var lightingType:String = ""
    var catalog:String = ""
    var filename:String = ""
    var internalID: Int = 0
    var uniqueEntryID:String = ""
}

class art: Codable{
    var donated:Bool
    var name:String
    var realArtworkTitle:String
    var hasFake:Bool
    var trueImage:String
    var fakeImage:String?

    
    
    //MARK: Initialization
    init(donated:Bool,name:String,realArtworkTitle:String,hasFake:Bool,trueImage:String,fakeImage:String?){
        self.donated = false
        self.name = name
        self.realArtworkTitle = realArtworkTitle
        self.hasFake = hasFake
        self.trueImage = trueImage
        self.fakeImage = fakeImage
    }
}
