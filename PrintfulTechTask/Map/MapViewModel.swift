//
//  MapViewModel.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation
import CoreLocation

protocol MapViewModelProtocol {
    var users: Binding<[MapAnnotationModel]> { get }

    func updateUserList(userList: [UserData])
    func updateUerLocation(location: [LocationUpdate])
}

class MapViewModel: MapViewModelProtocol {

    var users: Binding<[MapAnnotationModel]>
    var interacotr: MapInteractorProviding

    init(interactor: MapInteractorProviding = MapInteractor()) {
        self.users = Binding([])
        self.interacotr = interactor
        self.interacotr.viewModel = self
        self.interacotr.connect()
    }

    func updateUserList(userList: [UserData]) {

        self.users.value = userList.map { MapAnnotationModel(userData: $0)}
    }

    func updateUerLocation(location: [LocationUpdate]) {
        self.users.value.forEach { user in
            if let location = location.first(where: { $0.userId == user.id }) {
                user.updateLocation(lat: location.lat, lon: location.lon)
            }
        }
    }

}
