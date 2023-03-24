//
//  PreferenceTextfieldView-ViewModel.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/24/23.
//

import Foundation

extension PreferenceTextfieldView {
    // Manages character count of input for `PreferenceTextfieldView`.
    @MainActor class ViewModel: ObservableObject {
        // 16x2 LCD, so limit LCD message to 16.
        // Could be increased in the future if scrolling marquee text is implemented in Hydromon firmware.
        let maxCharacterCount = 16
        @Published var text = "" {
            didSet {
                if text.count > maxCharacterCount && oldValue.count <= maxCharacterCount {
                    self.text = oldValue
                }
            }
        }
    }
}
