//
//  MegaInterest.swift
//  ParsePersistencyPrototype
//
//  Created by Tsole on 6/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import RealmSwift

class MegaInterest: Object {

    dynamic var title: String = ""
    dynamic var interestType: String = ""
    dynamic var userID: String = ""
    dynamic var interestID: String = ""
    dynamic var identifier: String = ""
    dynamic var major: String = ""

    let matches = List<Match>()
    
    dynamic var languageIwantToPractice: String? = nil
    dynamic var skillLanguageIWantToPractice: String? = nil
    dynamic var skillLanguageISpeak: String? = nil
    dynamic var openness: String? = nil
    dynamic var languageISpeak: String? = nil

    dynamic var myAge: String? = nil
    dynamic var genderMatch: String? = nil
    dynamic var appearanceBody: String? = nil

    dynamic var appearanceHeight: String? = nil

    dynamic var sportType: String? = nil
    dynamic var skillLevel: String? = nil

    dynamic var spokenLanguages: String? = nil

    dynamic var boardGamesType: String? = nil

    dynamic var myGender: String? = nil
    dynamic var hobby: String? = nil
    dynamic var languagesISpeak: String? = nil


    dynamic var topic: String? = nil
    dynamic var frequency: String? = nil
}
