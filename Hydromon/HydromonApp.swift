//
//  HydromonApp.swift
//  Hydromon
//
//  Created by Spencer Hartland on 1/31/23.
//

import SwiftUI

@main
struct HydromonApp: App {
    @State private var presentedViews: [Presentable] = []
    
    var body: some Scene {
        WindowGroup {
            if presentedViews.count > 0 {
                switch presentedViews.last {
                case .colorPicker(let presentedView):
                    presentedView
                        .background { Colors.background.ignoresSafeArea() }
                        .preferredColorScheme(.dark)
                default:
                    EmptyView()
                }
            } else {
                ContentView(presentedViews: $presentedViews)
                    .background { Colors.background.ignoresSafeArea() }
                    .preferredColorScheme(.dark)
            }
        }
    }
}
