//
//  ContentView-ViewModel.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/14/23.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        private let httpRequestHandler = RequestHandler()
        
        @Published var connected = true // CHANGE to false
        @Published var preferences = PreferenceSet()
        
        func testConnection() {
            httpRequestHandler.testConnection { success, response in
                self.connected = true
                if !success { print(response) }
            }
        }
    }
}
