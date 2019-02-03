//
//  AnnotationPin.swift
//  mapTest
//
//  Created by Steve Wall on 6/22/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import MapKit

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
    }
    
    
}
