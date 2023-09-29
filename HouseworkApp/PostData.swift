//
//  PostData.swift
//  HouseworkApp
//
//  Created by shinotai on 2021/09/08.
//

import UIKit
import NCMB

class PostData{
    var objectId: String
    var user: NCMBUser
    var familyName: String
    var houseworkName: String
    var createDate: Date
    
    init(obj: NCMBObject) {
        objectId = obj.objectId
        user = obj.object(forKey: "user") as! NCMBUser
        familyName = obj.object(forKey: "familyName") as! String
        houseworkName = obj.object(forKey: "houseworkName") as! String
        createDate = obj.createDate
    }
}
