//
//  MapAnnotationModel.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation
import MapKit

class MapAnnotationModel: NSObject, MKAnnotation {
    var id: String
    var name: String
    var imageURL: String
    var lat: Double
    var lon: Double
    var image: Data?

    var title: String? {
        return name
    }

    dynamic var subtitle: String?

    dynamic var coordinate: CLLocationCoordinate2D

    convenience init(userData: UserData) {
        self.init(id: userData.id, name: userData.name, imageURL: userData.imageURL, lat: userData.lat, lon: userData.lon, image: userData.image)
    }

    init(id: String, name: String, imageURL: String, lat: Double, lon: Double, image: Data?) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.lat = lat
        self.lon = lon
        self.image = image
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    public func updateLocation(lat: Double, lon: Double) {
        UIView.animate(withDuration: 0.5) {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
}
