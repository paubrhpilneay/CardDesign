//
//  RestrauUserCoordinate.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 20/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import MapKit

class RestrauUserCoordinate: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
