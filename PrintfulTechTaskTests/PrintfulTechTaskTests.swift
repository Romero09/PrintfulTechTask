//
//  PrintfulTechTaskTests.swift
//  PrintfulTechTaskTests
//
//  Created by pavels.vetlugins on 07/11/2020.
//

import XCTest
@testable import PrintfulTechTask

class PrintfulTechTaskTests: XCTestCase {

    func testUserDataEncoding() {
        let rawData = "USERLIST 101,Jānis Bērziņš,https://i4.ifrype.com/profile/000/324/v1559116100/ngm_324.jpg,56.9495677035,24.1064071655;102,Pēteris Zariņš,https://i7.ifrype.com/profile/666/047/v1572553757/ngm_4666047.jpg,56.9503693176,24.1084241867;"

//        let range = rawData.index(rawData.startIndex, offsetBy: CommandType.USERLIST.rawValue.count + 1)..<rawData.endIndex
//        rawData.removeSubrange(range)
        let noPrefix = rawData.dropFirst(CommandType.USERLIST.rawValue.count + 1)
        let users = noPrefix.split(separator: ";")
        let parsedUsers = users.map { user -> User in
            let userData = user.split(separator: ",")
            return User(id: String(userData[0]), name: String(userData[1]), imageURL: String(userData[2]), lat: Double(userData[3])!, lon: Double(userData[4])!)
        }
        print("+++\(parsedUsers)")



    }

    func testUpdateEncoding() {
        let rawData = "UPDATE 101,56.9495677035,24.1064071655 UPDATE 102,56.9502698482,24.1093039513"

//        let range = rawData.index(rawData.startIndex, offsetBy: CommandType.USERLIST.rawValue.count + 1)..<rawData.endIndex
//        rawData.removeSubrange(range)
//        let noPrefix = rawData.dropFirst(CommandType.USERLIST.rawValue.count + 1)
        let res0 = rawData.dropFirst(CommandType.UPDATE.rawValue.count + 1)
        let res = res0.replacingOccurrences(of: " \(CommandType.UPDATE.rawValue) ", with: ";")
        let res2 = res.split(separator: ";")

        let pattern = #"(\d+),(\d+.\d+),(\d+.\d+)"#
        let strings = rawData.capturedGroups(withRegex: pattern)
        print("+++strings \(strings)")


//        let res2 = res.replacingOccurrences(of: " ", with: "")
//        let parsedUsers = users.map { user -> User in
//            let userData = user.split(separator: ",")
//            return User(id: String(userData[0]), name: String(userData[1]), imageURL: String(userData[2]), lat: Double(userData[3])!, lon: Double(userData[4])!)
//        }
        print("+++\(res2)")
    }

}
