//
//  HydromonStatusView-ViewModel.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/14/23.
//

import Foundation

extension HydromonStatusView {
    @MainActor class ViewModel: ObservableObject {
        private let httpRequestHandler = RequestHandler()
        
        @Published var fillLevel: Double = 0.0
        
        init() {
            httpRequestHandler.getFillLevel { success, response in
                if success {
                    guard let jsonData = response.data(using: .utf8) else {
                        print("There was an error getting data from the server's response.")
                        return
                    }
                    if let val = try? JSONDecoder().decode(Double.self, from: jsonData) {
                        self.fillLevel = val
                    } else {
                        print("There was an error decoding the value from the server's response.")
                    }
                }
            }
        }
    }
}
