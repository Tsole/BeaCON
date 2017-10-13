//
//  SavedInterest.swift
//  BeaCON
//
//  Created by Tsole on 6/12/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import RealmSwift

class SavedInterest: Object {

    dynamic var identifier: String = ""
    dynamic var interestType: String = ""
    dynamic var major: String = ""
    dynamic var title: String = ""
    dynamic var status: String = ""

    override static func primaryKey() -> String? {
        return "identifier"
    }

}