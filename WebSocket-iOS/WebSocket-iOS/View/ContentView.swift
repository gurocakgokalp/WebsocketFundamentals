//
//  ContentView.swift
//  WebSocket-iOS
//
//  Created by Gökalp Gürocak on 22.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ClickerViewModel()
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground).ignoresSafeArea()
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Image(systemName: "pointer.arrow.click.2")
                        .foregroundStyle(.green.gradient)
                        .font(.system(size: 60))
                    Text("Websocket Fundamentals")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Clicker using Server-Side Swift, SwiftUI, WebSocket")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                HStack {
                    HStack {
                        Image(systemName: "number")
                            .font(.caption)
                            .foregroundStyle(.green.gradient)
                        Text("Count: \(vm.clickerState.count)")
                            .bold()
                            .fontDesign(.rounded)
                            .font(.caption)
                            .textCase(.uppercase)
                            .tracking(1.5)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(Capsule().fill(Color(.systemBackground)))
                    HStack {
                        Image(systemName: "iphone")
                            .font(.caption)
                            .foregroundStyle(.green.gradient)
                        Text("Connected device: \(vm.clickerState.connectionCount)")
                            .bold()
                            .fontDesign(.rounded)
                            .font(.caption)
                            .textCase(.uppercase)
                            .tracking(1.5)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .background(Capsule().fill(Color(.systemBackground)))
                }
                
                Button(action: {
                    vm.sendClick()
                }) {
                    HStack {
                        Image(systemName: "pointer.arrow.ipad")
                        Text("Click")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(.green.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 10, x: 0, y: 5)
                }
                .padding()

            }
        }.onAppear {
            vm.connect()
        }.onDisappear {
            vm.disconnect()
        }
    }
}

#Preview {
    ContentView()
}
