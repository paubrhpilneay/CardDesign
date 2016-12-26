//
//  RestaurantModel.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 16/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import Foundation
import Firebase

class FIRDataObject: NSObject {
    
    let snapshot: FIRDataSnapshot
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    
    required init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        setValue(snapshot.key, forKey: "id")
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }
    }
}
//model class for restaurant
class RestaurantModel: FIRDataObject {
    var id: String = ""
    var name: String = ""
    var cuisines: String = ""
    var delivery: String = ""
    var mainImage: String = ""
    var cost: Int = 0
    var amenities: [String:Any] = [:]
    var rating: Int = 0
    var top3dish: String = ""
    var honors: String = ""
    var menu: String = ""
    var images: String = ""
}
