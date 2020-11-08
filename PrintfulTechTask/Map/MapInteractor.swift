//
//  MapInteractor.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation

class MapInteractor {

    var client: TCPClient?

    public func connect() {
        self.client = TCPClient()
        self.client?.onUserListEvent = { [weak self] data in self?.handleUserList(data: data) }
        self.client?.onUpdateEvent = { [weak self] data in self?.handleUpdateLocation(data: data) }
        self.client?.initializeConection()
    }

    private func handleUserList(data: String) {
        let noPrefix = data.dropFirst(CommandType.USERLIST.rawValue.count + 1)
        let rawUsers = noPrefix.split(separator: ";")
        let parsedUsers = rawUsers.compactMap { user -> User? in
            let userData = user.split(separator: ",")
            return User.initFrom(userData: userData)
        }
        print("+++\(parsedUsers)")
    }

    private func handleUpdateLocation(data: String) {
        let noPrefix = data.dropFirst(CommandType.UPDATE.rawValue.count + 1)
        let formatted = noPrefix.replacingOccurrences(of: "\(CommandType.UPDATE.rawValue)", with: ";")
        let rawLocation = formatted.split(separator: ";")
        let parsedLocation = rawLocation.compactMap { location -> LocationUpdate? in
            let locationData = String(location)
            return LocationUpdate.initFrom(locationData: locationData)
        }

        print("+++\(parsedLocation)")
    }
}
