//
//  TCPClient.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation
import CocoaAsyncSocket

enum CommandType: String {
    case AUTHORIZE
    case USERLIST
    case UPDATE
}

protocol TCPClientProviding {
    var onUserListEvent: ((String) -> ())? { get set }
    var onUpdateEvent: ((String) -> ())? { get set }
    func initializeConection()
}

class TCPClient: NSObject, TCPClientProviding {

    let address = "ios-test.printful.lv"
    let port: UInt16 = 6111

    private var socket: GCDAsyncSocket?
    
    public var onUserListEvent: ((String) -> ())?
    public var onUpdateEvent: ((String) -> ())?

    public func initializeConection() {
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global())
        try? self.socket?.connect(toHost: address, onPort: port)
    }

    deinit {
        self.socket?.disconnect()
    }

}

// MARK: GCDAsyncSocketDelegate
extension TCPClient: GCDAsyncSocketDelegate {

    func socket(_ socket : GCDAsyncSocket, didConnectToHost host:String, port p:UInt16) {
        let data = "\(CommandType.AUTHORIZE.rawValue) pavelvetl92@gmail.com\n".data(using: .utf8)
        socket.write(data, withTimeout: -1, tag: 1)
        socket.readData(withTimeout: -1, tag: 1)
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 1)
        let eventData = String(decoding: data, as: UTF8.self)

        if eventData.hasPrefix(CommandType.UPDATE.rawValue) {
            self.onUpdateEvent?(eventData)
        } else if eventData.hasPrefix(CommandType.USERLIST.rawValue) {
            self.onUserListEvent?(eventData)
        }
    }

}
