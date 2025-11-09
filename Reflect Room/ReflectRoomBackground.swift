//
//  ReflectRoomBackground.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 10/30/25.
//

import SwiftUI

struct ReflectRoomBackground: View {
    @Environment(\.colorScheme) private var scheme
    @State private var hueRotation: Double = 0

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: backgroundColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(.degrees(hueRotation))
        .animation(.linear(duration: 12).repeatForever(autoreverses: true), value: hueRotation)
        .onAppear { hueRotation = 360 }
        .ignoresSafeArea(.all)
        .overlay(Color.clear) // Forces full redraw and prevents split artifacts
    }

    private var backgroundColors: [Color] {
        if scheme == .dark {
            return [
                Color(red: 80/255, green: 80/255, blue: 90/255),
                Color(red: 30/255, green: 30/255, blue: 40/255)
            ]
        } else {
            return [
                Color(red: 216/255, green: 190/255, blue: 255/255),
                Color.white
            ]
        }
    }
}
