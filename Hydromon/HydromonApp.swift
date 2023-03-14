//
//  HydromonApp.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import SwiftUI

@main
struct HydromonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background {
                    Colors.background
                        .ignoresSafeArea()
                }
                .preferredColorScheme(.dark)
        }
    }
}
