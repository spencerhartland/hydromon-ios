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
    @Binding var preference: String
    
    var body: some View {
        VStack {
            VStack(alignment: .trailing) {
                ZStack {
                    Image(textfieldBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondaryBackground)
                        .overlay {
                            HStack {
                                TextField(title, text: $viewModel.text)
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
                CharacterCountDisplay(currentCharacterCount: self.viewModel.text.count, maxCharacterCount: self.viewModel.maxCharacterCount)
            }
            .padding(.top, 32)
            .padding(.horizontal, 8)
            Spacer()
            LargeButton(title: (viewModel.text.isEmpty ? cancelText : String(format: buttonTextTemplate, title)).uppercased(), color: Colors.primary) {
                if !viewModel.text.isEmpty {
                    self.preference = self.viewModel.text
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        }
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
            VStack(alignment: .trailing) {
                ZStack {
                    Image(textfieldBackgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.secondaryBackground)
                        .overlay {
                            HStack {
                                TextField(title, text: $input)
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
                Text(footer)
                    .font(Fonts.regular(size: 8))
                    .foregroundColor(Colors.secondary)
            }
            .padding(.top, 32)
            .padding(.horizontal, 8)
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
        PreferenceNumberEntryView(title: "Alert Timeout", footer: "The duration of a drink reminder alert in seconds.", preference: .constant(0))
    }
}
