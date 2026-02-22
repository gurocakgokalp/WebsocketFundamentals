//
//  Model.swift
//  Backend
//
//  Created by Gökalp Gürocak on 22.02.2026.
//
import Vapor

struct ClickerState: Codable {
    let count: Int
    let connectionCount: Int
}

actor Clicker {
    var connections: [WebSocket] = []
    var count: Int = 0
    
    func addConnection(ws: WebSocket) {
        connections.append(ws)
    }
    
    func removeConn(ws: WebSocket) {
        connections.removeAll { $0 === ws }
        // true donenler silincek. yani arrayi dolasiyor ws ye esit olani siliyor.
    }
    
    func incrementCount() -> Int {
        count += 1
        return count
    }
    
    func broadcast(message: ClickerState) async {
        guard let data = try? JSONEncoder().encode(message),
              let json = String(data: data, encoding: .utf8) else {
            return
        }
        for ws in connections {
            if !ws.isClosed {
                do {
                    try await ws.send(json)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

let clickerRoom = Clicker()
