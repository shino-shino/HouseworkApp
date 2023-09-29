//
//  Housework.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/08.
//

import UIKit
import NCMB

class Housework {
    var objectId: String
    var familyName: String
    var houseworkName: String
    var houseworkPoint: Int

//    init(objectId: String, familyName: String, houseworkName: String, houseworkPoint: Int) {
//        self.objectId = objectId
//        self.familyName = familyName
//        self.houseworkName = houseworkName
//        self.houseworkPoint = houseworkPoint
//    }
    
    init(obj: NCMBObject) {
        objectId = obj.objectId
        familyName = obj.object(forKey: "familyName") as! String
        houseworkName = obj.object(forKey: "houseworkName") as! String
        houseworkPoint = obj.object(forKey: "houseworkPoint") as! Int
    }
}
