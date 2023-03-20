//
//  ControlView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/14/23.
//

import SwiftUI

struct ControlView: View {
    private let colorpickerIndicatorImageName = "control_color-picker-indicator"
    private let colorPickerBackgroundImageName = "control_color-picker-bg"
    private let colorPickerHighlightImageName = "control_color-picker-highlight"
    private let texfieldDisclosureIndicatorImageName = "control_textfield-disclosure-indicator"
    private let textfieldDisclosureBackgroundImageName = "control_textfield-disclosure-bg"
    private let textfieldDisclosureHighlightImageName = "control_textfield-disclosure-highlight"
    private let disclosureIcon = "chevron.right"
    private let lcdStandbyMessageFooter = "This message will be displayed on the LCD during standby when you pick up your Hydromon."
    private let lcdStandbyMessgageControlTitle = "LCD Standby Message"
    
    @ObservedObject var viewModel: ContentView.ViewModel
    @Binding var presentedViews: [Presentable]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                colorPickerButton(
                    title: "LCD STANDBY",
                    color: self.viewModel.preferences.LCDStandbyColor.color())
                    .onTapGesture {
                        self.presentedViews.append(.colorPicker(
                            CustomColorPicker(component: .LCD, mode: .standby, action: { rgb in
                                self.viewModel.updatePreference(.LCDStandbyColor, value: rgb)
                                self.presentedViews.removeLast()
                        })))
                    }
                //colorPickerButton(title: "LED STANDBY")
            }
            HStack {
                //colorPickerButton(title: "LCD REMINDER")
                //colorPickerButton(title: "LED REMINDER")
            }
            .padding(.bottom, 16)
            textfieldDisclosure(title: lcdStandbyMessgageControlTitle, currentValue: viewModel.preferences.LCDStandbyMessage, footer: lcdStandbyMessageFooter)
        }
    }
    
    func colorPickerButton(title: String, color: Color) -> some View {
        return ZStack {
            Image(colorpickerIndicatorImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
            Image(colorPickerBackgroundImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Image(colorPickerHighlightImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
            HStack {
                Text(title.uppercased())
                Spacer()
            }
            .foregroundColor(Colors.primary)
            .font(Fonts.semibold(size: 14))
            .padding(.leading, 32)
        }
        .foregroundColor(Colors.secondaryBackground)
        .padding(.horizontal, 8)
    }
    
    func textfieldDisclosure(title: String, currentValue: String, footer: String) -> some View {
        VStack(alignment: .leading) {
            ZStack {
                Image(texfieldDisclosureIndicatorImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(textfieldDisclosureBackgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(textfieldDisclosureHighlightImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Colors.secondary)
                HStack {
                    Text(title.uppercased())
                        .font(Fonts.semibold(size: 14))
                        .padding(.leading, 32)

                    Spacer()

                    HStack {
                        Text(currentValue.uppercased())
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
            .foregroundColor(Colors.secondaryBackground)
            .padding(.horizontal, 8)
            Text(footer)
                .font(Fonts.regular(size: 8))
                .padding([.leading, .trailing], 32)
                .foregroundColor(Colors.secondary)
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(viewModel: .init(), presentedViews: .constant(.init()))
    }
}
