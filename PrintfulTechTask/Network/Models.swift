//
//  Models.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation

struct UserData {
    var id: String
    var name: String
    var imageURL: String
    var lat: Double
    var lon: Double

    static func initFrom(userData: [Substring.SubSequence]) -> UserData? {
        if userData.count == 5, let lat = Double(userData[3]), let lon =  Double(userData[4]){
            return UserData(id: String(userData[0]), name: String(userData[1]), imageURL: String(userData[2]), lat: lat, lon: lon)
        }
        return nil
    }

}

struct LocationUpdate {
    var userId: String
    var lat: Double
    var lon: Double

    static func initFrom(locationData: String) -> LocationUpdate? {
        let pattern = #"(\d+),(\d+.\d+),(\d+.\d+)"#
        let parsedData = locationData.capturedGroups(withRegex: pattern)
        if parsedData.count == 3, let lat = Double(parsedData[1]), let lon =  Double(parsedData[2]){
            return LocationUpdate(userId: String(parsedData[0]), lat: lat, lon: lon)
        }
        return nil
    }
}
