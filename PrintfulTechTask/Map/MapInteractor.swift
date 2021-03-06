//
//  MapInteractor.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation

protocol MapInteractorProviding {
    var viewModel: MapViewModelProtocol? { get set }
    func connect()
}

class MapInteractor: MapInteractorProviding {

    public weak var viewModel: MapViewModelProtocol?
    private var client: TCPClientProviding

    init(client: TCPClientProviding = TCPClient()) {
        self.client = client
    }

    public func connect() {
        self.client.onUserListEvent = { [weak self] data in self?.handleUserList(data: data) }
        self.client.onUpdateEvent = { [weak self] data in self?.handleUpdateLocation(data: data) }
        self.client.initializeConection()
    }

    private func handleUserList(data: String) {
        let noPrefix = data.dropFirst(CommandType.USERLIST.rawValue.count + 1)
        let rawUsers = noPrefix.split(separator: ";")
        let parsedUsers = rawUsers.compactMap { user -> UserData? in
            let userData = user.split(separator: ",")
            var user = UserData.initFrom(userData: userData)
            let image = self.fetchUserImage(urlPath: user?.imageURL)
            user?.image = image
            return user
        }

        DispatchQueue.main.async {
            self.viewModel?.updateUserList(userList: parsedUsers)
        }
    }

    private func handleUpdateLocation(data: String) {
        let noPrefix = data.dropFirst(CommandType.UPDATE.rawValue.count + 1)
        let formatted = noPrefix.replacingOccurrences(of: "\(CommandType.UPDATE.rawValue)", with: ";")
        let rawLocation = formatted.split(separator: ";")
        let parsedLocation = rawLocation.compactMap { location -> LocationUpdate? in
            let locationData = String(location)
            return LocationUpdate.initFrom(locationData: locationData)
        }
        
        DispatchQueue.main.async {
            self.viewModel?.updateUerLocation(location: parsedLocation)
        }
    }

    private func fetchUserImage(urlPath: String?) -> Data? {
        guard let urlPath = urlPath, let url = URL(string: urlPath) else { return nil }
        return try? Data(contentsOf: url)
    }
    
}
