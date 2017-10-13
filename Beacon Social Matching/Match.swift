//
//  Match.swift
//  ParsePersistencyPrototype
//
//  Created by Tsole on 8/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import RealmSwift

class Match: Object {

    dynamic var identifier: String = ""
    dynamic var broadcasterMinor: String = ""
    dynamic var broadcasterId: String = ""
    dynamic var listenerMinor: String = ""
    dynamic var listenerId: String = ""
    dynamic var lastNotified: NSDate =  NSDate()
    dynamic var keyBroadcasterMinorIdentifier: String = ""

    override static func primaryKey() -> String? {
        return "keyBroadcasterMinorIdentifier" //it is the: broadcasterMinor + identifier
    }
}
