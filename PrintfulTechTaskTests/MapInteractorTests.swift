//
//  PrintfulTechTaskTests.swift
//  PrintfulTechTaskTests
//
//  Created by pavels.vetlugins on 07/11/2020.
//

import XCTest
@testable import PrintfulTechTask

private class TCPClientMock: TCPClientProviding {
    var onUserListEvent: ((String) -> ())?

    var onUpdateEvent: ((String) -> ())?

    func initializeConection() {
    }

    func callOnUserListEvent(data: String) {
        self.onUserListEvent?(data)
    }

    func callOnUpdateEvent(data: String) {
        self.onUpdateEvent?(data)
    }

}

private class MapViewModelMock: MapViewModelProtocol {
    var annotations: Binding<[MapAnnotationModel]>

    var didCallUpdateUserList: (([UserData]) -> Void)?
    var didCallUpdateUerLocation: (([LocationUpdate]) -> Void)?

    func updateUserList(userList: [UserData]) {
        self.didCallUpdateUserList?(userList)
    }

    func updateUerLocation(location: [LocationUpdate]) {
        self.didCallUpdateUerLocation?(location)
    }

    init() {
        self.annotations = Binding([])
    }


}

class MapInteractorTests: XCTestCase {

    func testMapInteractorHandleData() {
        let rawDataUsers = "USERLIST 101,Jānis Bērziņš,https://i4.ifrype.com/profile/000/324/v1559116100/ngm_324.jpg,56.9495677035,24.1064071655;102,Pēteris Zariņš,https://i7.ifrype.com/profile/666/047/v1572553757/ngm_4666047.jpg,56.9503693176,24.1084241867;"
        let rawDataLocations = "UPDATE 101,56.9495677035,24.1064071655 UPDATE 102,56.9502698482,24.1093039513"

        let tcpClient = TCPClientMock()
        let viewModel = MapViewModelMock()
        let interactor = MapInteractor(client: tcpClient)
        interactor.viewModel = viewModel

        interactor.connect()

        var expectation = XCTestExpectation(description: "Did receeive user list")
        viewModel.didCallUpdateUserList = { userList in
            XCTAssert(userList.count == 2)
            XCTAssert(userList[0].id == "101")
            XCTAssert(userList[0].name == "Jānis Bērziņš")
            XCTAssert(userList[0].imageURL == "https://i4.ifrype.com/profile/000/324/v1559116100/ngm_324.jpg")
            XCTAssert(userList[0].lat == 56.9495677035)
            XCTAssert(userList[0].lon == 24.1064071655)
            XCTAssert(userList[1].id == "102")
            XCTAssert(userList[1].name == "Pēteris Zariņš")
            XCTAssert(userList[1].imageURL == "https://i7.ifrype.com/profile/666/047/v1572553757/ngm_4666047.jpg")
            XCTAssert(userList[1].lat == 56.9503693176)
            XCTAssert(userList[1].lon == 24.1084241867)
            expectation.fulfill()
        }

        tcpClient.callOnUserListEvent(data: rawDataUsers)
        wait(for: [expectation], timeout: 2.0)


        expectation = XCTestExpectation(description: "Did receeive location update")
        viewModel.didCallUpdateUerLocation = { userLocation in
            XCTAssert(userLocation.count == 2)
            XCTAssert(userLocation[0].userId == "101")
            XCTAssert(userLocation[0].lat == 56.9495677035)
            XCTAssert(userLocation[0].lon == 24.1064071655)
            XCTAssert(userLocation[1].userId == "102")
            XCTAssert(userLocation[1].lat == 56.9502698482)
            XCTAssert(userLocation[1].lon == 24.1093039513)
            expectation.fulfill()
        }

        tcpClient.callOnUpdateEvent(data: rawDataLocations)
        wait(for: [expectation], timeout: 2.0)
    }

}
