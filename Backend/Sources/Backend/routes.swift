import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "server online"
    }

    // ws://localhost:8080/clicker
    app.webSocket("clicker") { rq, ws in
        print("new device connected.")
        
        Task {
            await clickerRoom.addConnection(ws: ws)
            
            let currentCount = await clickerRoom.count
            let connectionCount = await clickerRoom.connections.count
            let message = ClickerState(count: currentCount, connectionCount: connectionCount)
            
            guard let data = try? JSONEncoder().encode(message),
                  let json = String(data: data, encoding: .utf8) else {
                return
            }
            
            await clickerRoom.broadcast(
                message: ClickerState(
                    count: currentCount,
                    connectionCount: connectionCount
                )
            )
        }
        
        ws.onText { ws, text in
            if text == "click" {
                print("someone clicked button")
                
                Task {
                    let newCount = await clickerRoom.incrementCount()
                    let connectionCount = await clickerRoom.connections.count
                    await clickerRoom.broadcast(message: ClickerState(count: newCount, connectionCount: connectionCount))
                }
            }
        }
        
        ws.onClose.whenComplete { result in
            print("a device disconnected.")
            Task {
                await clickerRoom.removeConn(ws: ws)
                
                let currentCount = await clickerRoom.count
                let connectionCount = await clickerRoom.connections.count
                let message = ClickerState(count: currentCount, connectionCount: connectionCount)
                
                guard let data = try? JSONEncoder().encode(message),
                      let json = String(data: data, encoding: .utf8) else {
                    return
                }
                
                await clickerRoom.broadcast(
                    message: ClickerState(
                        count: currentCount,
                        connectionCount: connectionCount
                    )
                )
            }
        }
    }
}
