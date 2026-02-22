//
//  ClickerViewModel.swift
//  WebSocket-iOS
//
//  Created by Gökalp Gürocak on 22.02.2026.
//
import SwiftUI
import Combine

class ClickerViewModel: ObservableObject {
    @Published var clickerState: ClickerState = ClickerState(count: 0, connectionCount: 0)
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        guard let url = URL(string: "ws://127.0.0.1:8080/clicker") else {
            return
        }
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        
        webSocketTask?.resume()
        
        listenForMessages()
    }
    
    private func listenForMessages() {
        webSocketTask?.receive { message in
            switch message {
            case .success(let success):
                switch success {
                case .string(let text):
                    let data = Data(text.utf8)
                    let clickerState = self.decode(data: data)
                    DispatchQueue.main.async {
                        self.clickerState = clickerState
                    }
                case .data(let data):
                    print("data format coming: \(data)")
                @unknown default:
                    break
                }
                
                self.listenForMessages()
            case .failure(let failure):
                print("websocket listenin' error: \(failure.localizedDescription)")
            }
        }
    }
    
    func decode(data: Data) -> ClickerState {
        do {
            return try JSONDecoder().decode(ClickerState.self, from: data)
        } catch {
            print("decoding err: \(error.localizedDescription)")
            return ClickerState(count: 0, connectionCount: 0)
        }
    }
    
    func sendClick() {
        let message = URLSessionWebSocketTask.Message.string("click")
        
        webSocketTask?.send(message) { err in
            if let err = err {
                print("failure when sending message: \(err.localizedDescription)")
            } else {
                print("click message sent successfully")
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
