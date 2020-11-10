//
//  MapViewModel.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation
import CoreLocation
import UIKit

protocol MapViewModelProtocol: class {
    var annotations: Binding<[MapAnnotationModel]> { get }

    func updateUserList(userList: [UserData])
    func updateUerLocation(location: [LocationUpdate])
}

class MapViewModel: MapViewModelProtocol {

    var annotations: Binding<[MapAnnotationModel]>
    var interacotr: MapInteractorProviding

    init(interactor: MapInteractorProviding = MapInteractor()) {
        self.annotations = Binding([])
        self.interacotr = interactor
        self.interacotr.viewModel = self
        self.interacotr.connect()
    }

    func updateUserList(userList: [UserData]) {

        let annotations = userList.map { MapAnnotationModel(userData: $0) }
        annotations.forEach { annotation in
            self.getAddress(lat: annotation.lat, lon: annotation.lon) { address in
                annotation.subtitle = address
            }
        }
        self.annotations.value = annotations
    }

    func updateUerLocation(location: [LocationUpdate]) {
        self.annotations.value.forEach { user in
            if let location = location.first(where: { $0.userId == user.id }) {
                self.getAddress(lat: location.lat, lon: location.lon) { address in
                    user.subtitle = address
                }
                UIView.animate(withDuration: 0.5) {
                    user.updateLocation(lat: location.lat, lon: location.lon)
                }
            }
        }
    }

    private func getAddress(lat: Double, lon: Double, completion: @escaping (String?) -> Void) {
        CLGeocoder.init().reverseGeocodeLocation(CLLocation.init(latitude: lat, longitude: lon)) { (places, _) in
            if let places = places {
                completion(places[0].name)
            } else {
                completion(nil)
            }
        }
    }

}
