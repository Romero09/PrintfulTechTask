//
//  MapViewModel.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation
import CoreLocation

protocol MapViewModelProtocol {
    var users: Binding<[User]> { get }

    func updateUserList(userList: [User])
    func updateUerLocation(location: [LocationUpdate])
}

class MapViewModel: MapViewModelProtocol {

    var users: Binding<[User]>
    var interacotr: MapInteractorProviding

    init(interactor: MapInteractorProviding = MapInteractor()) {
        self.users = Binding([])
        self.interacotr = interactor
        self.interacotr.viewModel = self
        self.interacotr.connect()
    }

    func updateUserList(userList: [User]) {
        self.users.value = userList
    }

    func updateUerLocation(location: [LocationUpdate]) {
        let currentUsers = self.users.value

        let updated = currentUsers.map { user -> User in
            var updatedUser = user
            if let location = location.first(where: { $0.userId == user.id }) {
                updatedUser.lat = location.lat
                updatedUser.lon = location.lon
            }
            return updatedUser
        }

        self.users.value = updated
    }

}
