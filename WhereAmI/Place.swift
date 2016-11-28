//
//  Place.swift
//  WhereAmI
//
//  Created by Sam N on 10/28/16.
//  Copyright © 2016 Sam N. All rights reserved.
//

import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }

}
