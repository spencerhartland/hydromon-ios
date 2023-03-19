//
//  HydromonApp.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import SwiftUI

@main
struct HydromonApp: App {
    @State private var presentedViews: [AnyView] = []
    
    var body: some Scene {
        WindowGroup {
            if presentedViews.count > 0 {
                presentedViews.last
                    .background { Colors.background.ignoresSafeArea() }
                    .preferredColorScheme(.dark)
            } else {
                ContentView(presentedViews: $presentedViews)
                    .background { Colors.background.ignoresSafeArea() }
                    .preferredColorScheme(.dark)
            }
        }
    }
}
