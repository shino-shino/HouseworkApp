//
//  Family.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/08.
//

import UIKit
import NCMB

class Family {
    var objectId: String
    var familyName: String
    var aikotoba: String

    init(objectId: String, familyName: String, aikotoba: String) {
        self.objectId = objectId
        self.familyName = familyName
        self.aikotoba = aikotoba
    }
    
    init(obj: NCMBObject) {
        objectId = obj.objectId
        familyName = obj.object(forKey: "familyName") as! String
        aikotoba = obj.object(forKey: "aikotoba") as! String
    }
}

