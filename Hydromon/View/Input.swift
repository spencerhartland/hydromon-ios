//
//  PreferenceTextfieldView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 3/23/23.
//

import SwiftUI

struct PreferenceTextfieldView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let textfieldBackgroundImageName = "textfield-background"
    private let xmarkButtonImageName = "xmark-button"
    private let cancelText = "Cancel"
    private let buttonTextTemplate = "Set %@"
    
    @StateObject private var viewModel = ViewModel()
    
    let title: String
    let footer: String
    @Binding var preference: String
    
    var body: some View {
        VStack {
            VStack(alignment: .trailing) {
                HStack {
                    Text(title.uppercased())
                        .font(Fonts.bold(size: 16))
                        .foregroundColor(Colors.primary)
                    Spacer()
                }
                ZStack {
                    Image(textfieldBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondaryBackground)
                        .overlay {
                            HStack {
                                TextField(preference, text: $viewModel.text)
                                    .font(Fonts.medium(size: 16))
                                    .foregroundColor(Colors.primary)
                                    .padding(.leading)
                                Image(xmarkButtonImageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Colors.secondary)
                                    .padding()
                                    .onTapGesture {
                                        self.viewModel.text = ""
                                    }
                            }
                        }
                }
                Text(footer)
                    .font(Fonts.regular(size: 10))
                    .foregroundColor(Colors.secondary)
                CharacterCountDisplay(currentCharacterCount: self.viewModel.text.count, maxCharacterCount: self.viewModel.maxCharacterCount)
            }
            Spacer()
            LargeButton(title: (viewModel.text.isEmpty ? cancelText : String(format: buttonTextTemplate, title)).uppercased(), color: Colors.primary) {
                if !viewModel.text.isEmpty {
                    self.preference = self.viewModel.text
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 8)
        .background {
            Colors.background
                .ignoresSafeArea()
        }
    }
}

struct PreferenceNumberEntryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let textfieldBackgroundImageName = "textfield-background"
    private let xmarkButtonImageName = "xmark-button"
    private let cancelText = "Cancel"
    private let buttonTextTemplate = "Set %@"
    
    @State private var input = ""
    
    let title: String
    let footer: String
    @Binding var preference: Int
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(title.uppercased())
                    .font(Fonts.bold(size: 16))
                    .foregroundColor(Colors.primary)
                ZStack {
                    Image(textfieldBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondaryBackground)
                        .overlay {
                            HStack {
                                TextField(String(preference), text: $input)
                                    .keyboardType(.numberPad)
                                    .font(Fonts.medium(size: 16))
                                    .foregroundColor(Colors.primary)
                                    .padding(.leading)
                                Image(xmarkButtonImageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Colors.secondary)
                                    .padding()
                                    .onTapGesture {
                                        self.input = ""
                                    }
                            }
                        }
                }
                HStack {
                    Spacer()
                    Text(footer)
                        .font(Fonts.regular(size: 10))
                        .foregroundColor(Colors.secondary)
                }
            }
            Spacer()
            LargeButton(title: (input.isEmpty ? cancelText : String(format: buttonTextTemplate, title)).uppercased(), color: Colors.primary) {
                if !input.isEmpty {
                    guard let entry = Int(self.input) else {
                        // TODO: Add some sort of error UI
                        print("Please enter a number.")
                        return
                    }
                    self.preference = entry
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 8)
        .background {
            Colors.background
                .ignoresSafeArea()
        }
    }
}

fileprivate struct CharacterCountDisplay: View {
    private let characterCountBarImageName = "control_color-picker-bar"
    private let characterCountTextTemplate = "%d / %d"
    
    private let currentCharacterCount: Int
    private let maxCharacterCount: Int
    private let gradient: LinearGradient
    
    init(currentCharacterCount: Int, maxCharacterCount: Int) {
        self.currentCharacterCount = currentCharacterCount
        self.maxCharacterCount = maxCharacterCount
        
        let location = CGFloat(currentCharacterCount) / CGFloat(maxCharacterCount)
        self.gradient = LinearGradient(stops: [
            .init(color: (location >= 0.85 ? .red : location >= 0.75 ? .orange : Colors.primary), location: location),
            .init(color: Colors.secondaryBackground, location: location + (location > 0.0 ? 0.05 : 0.0))
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        HStack {
            Image(characterCountBarImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay {
                    gradient
                        .mask {
                            Image(characterCountBarImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                }
                .background {
                    gradient
                        .mask {
                            Image(characterCountBarImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .blur(radius: 8)
                }
                .frame(width: 64)
            Text(String(format: characterCountTextTemplate, self.currentCharacterCount, self.maxCharacterCount))
                .font(Fonts.medium(size: 12))
                .foregroundColor(Colors.primary)
                .frame(width: 32)
        }
    }
}

struct Input_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceTextfieldView(title: "LCD Alert Message", footer: "This message will be displayed on the LCD during a drink reminder alert.", preference: .constant("Drink now!"))
        
        PreferenceNumberEntryView(title: "Sip Size", footer: "The average amount of water consumed in one 'sip,' in milileters.", preference: .constant(60))
    }
}
