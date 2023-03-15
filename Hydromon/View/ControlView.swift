//
//  ControlView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/14/23.
//

import SwiftUI

struct ControlView: View {
    private let controlIndicatorImageName = "control_indicator-decoration"
    private let textfieldDisclosureBackgroundImageName = "control_textfield-disclosure-button"
    private let textfieldDisclosureHighlightImageName = "control_textfield-disclosure-button-highlight"
    private let disclosureIcon = "chevron.right"
    private let LCDStandbyMessageFooter = "The message displayed on the LCD during standy when the device is picked up and for a short time after."
    private let LCDStandbyMessgageControlTitle = "LCD Standby Message"
    
    @Binding var preferences: PreferenceSet
    
    var body: some View {
        textfieldDisclosureButton
    }
    
    private var textfieldDisclosureButton: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Spacer()
                Image(controlIndicatorImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                ZStack(alignment: .leading) {
                    Image(textfieldDisclosureBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image(textfieldDisclosureHighlightImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondary)
                    HStack {
                        Text(LCDStandbyMessgageControlTitle.uppercased())
                            .font(Fonts.semibold(size: 14))
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        HStack {
                            Text(preferences.LCDStandbyMessage.uppercased())
                                .font(Fonts.semibold(size: 14))
                            Image(systemName: disclosureIcon)
                                .font(.system(size: 10))
                                .offset(y: -0.5)
                        }
                        .foregroundColor(Colors.secondary)
                        .padding(.trailing, 24)
                    }
                    .foregroundColor(Colors.primary)
                }
                Spacer()
            }
            .foregroundColor(Colors.secondaryBackground)
            .frame(height: 40)
            Text(LCDStandbyMessageFooter)
                .font(Fonts.regular(size: 8))
                .padding([.leading, .trailing], 32)
                .foregroundColor(Colors.secondary)
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(preferences: .constant(.init()))
    }
}
