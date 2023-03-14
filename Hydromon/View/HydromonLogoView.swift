//
//  HydromonLogoView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/5/23.
//

import SwiftUI

struct HydromonLogoView: View {
    private let hydromonText = "hydromon"
    private let modelText = "hydration monitor model M00000001"
    
    var body: some View {
        VStack(alignment: .leading, spacing: -8) {
            Text(hydromonText.uppercased())
                .font(Fonts.bold(size: 38))
                .foregroundColor(Colors.primary)
                .glow(Colors.primary, intensity: 0.65)
            Text(modelText.uppercased())
                .font(Fonts.semibold(size: 8))
                .foregroundColor(Colors.secondary)
        }
    }
}

struct HydromonLogoView_Previews: PreviewProvider {
    static var previews: some View {
        HydromonLogoView()
            .background {
                Colors.background
                    .ignoresSafeArea()
            }
    }
}
