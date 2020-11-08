//
//  TCPClient.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation
import CocoaAsyncSocket

let addr = "ios-test.printful.lv"
let port: UInt16 = 6111

enum CommandType: String {
    case AUTHORIZE
    case USERLIST
    case UPDATE
}

class TCPClient: NSObject {

    private var socket: GCDAsyncSocket?
    
    public var onUserListEvent: ((String) -> ())?
    public var onUpdateEvent: ((String) -> ())?

    public func initializeConection() {
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: .main)
        do {
            try socket?.connect(toHost: addr, onPort: port)
        } catch let e {
           print(e)
        }

        let data = "\(CommandType.AUTHORIZE.rawValue) pavelvetl92@gmail.com \n".data(using: .utf8)
        socket?.write(data, withTimeout: -1, tag: 1)
        socket?.readData(withTimeout: -1, tag: 1)
    }

    deinit {
        self.socket?.disconnect()
    }

}

extension TCPClient: GCDAsyncSocketDelegate {

    func socket(_ socket : GCDAsyncSocket, didConnectToHost host:String, port p:UInt16) {
        print("Connected to \(addr) on port \(port).")
    }

    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("data has written tag \(tag)")
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 1)
        let eventData = String(decoding: data, as: UTF8.self)

        if eventData.hasPrefix(CommandType.UPDATE.rawValue) {
            self.onUpdateEvent?(eventData)
        } else if eventData.hasPrefix(CommandType.USERLIST.rawValue) {
            self.onUserListEvent?(eventData)
        }

        print("Data: \(eventData) on tag: \(tag).")
    }

}
