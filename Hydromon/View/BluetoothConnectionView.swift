//
//  BluetoothTestView.swift
//  Hydromon
//
//  Created by Spencer Hartland on 5/2/23.
//

import SwiftUI
import AVKit

fileprivate protocol StringCollection {
    static var header: String { get }
    static var title: String { get }
    static var description: String { get }
}

struct BluetoothConnectionView: View {
    private struct Strings {
        struct Ready: StringCollection {
            static let header = "Search for Hydromon"
            static let title = "Ready to connect"
            static let description = "Tap [begin] to search for and connect to your Hydromon."
            static let button = "Begin"
        }
        
        struct Searching: StringCollection {
            static let header = "Searching"
            static let title = "Searching for your hydromon"
            static let description = "Please ensure that your Hydromon is powered on and within range."
            static let button = "Stop"
        }
        
        struct Found: StringCollection {
            static let header = "Hydromon found"
            static let title = "A Hydromon was discovered"
            static let description = "Tap [connect] if this is your Hydromon."
            static let button = "Connect"
        }
        
        struct Connected: StringCollection {
            static let header = "Connected"
            static let title = "Connected to your Hydromon"
            static let description = "Tap [continue] to get started."
            static let button = "Continue"
        }
        
        struct BluetoothUnavailable: StringCollection {
            static let header = "Bluetooth unavailable"
            static let title = "Turn on Bluetooth"
            static let description = "This app uses Bluetooth to communicate with your Hydromon."
            static let iphoneSlashSymbolName = "iphone.slash.circle.fill"
            static let exclamationSymbolName = "exclamationmark.circle.fill"
        }
    }
    private let bgColors = [
        Color(red: 10/255, green: 10/255, blue: 10/255),
        Color(red: 6/255, green: 6/255, blue: 6/255)
    ]
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    @State var variableValue: Double = 0.0
    @State private var currentState: BluetoothState = .unavailable
    @StateObject var bluetoothManager: BluetoothManager
    @Binding var shouldShowControlView: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: bgColors, startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                ZStack {
                    HydromonConnectedAnimationView(currentState: $currentState)
                    if bluetoothManager.isSwitchedOn {
                        if currentState != .connected {
                            EllipsisAnimationView(currentState: $currentState, variableValue: $variableValue)
                        }
                    } else {
                        Image(systemName: Strings.BluetoothUnavailable.exclamationSymbolName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 64)
                            .foregroundStyle(Colors.primary)
                            .glow(Colors.primary, intensity: 0.33)
                            .opacity(0.25)
                    }
                }
                if bluetoothManager.isSwitchedOn {
                    // Bluetooth is on, looking for Hydromon
                    ConnectionPopupView(currentState: $currentState, variableValue: $variableValue) {
                        // Perform connection to peripheral
                        bluetoothManager.connect(peripheral: bluetoothManager.peripheral)
                    } dismiss: {
                        // Connection established, dismiss this view
                        shouldShowControlView = true
                    }
                    Spacer()
                } else {
                    // Bluetooth is not available, ask to turn it on
                    AlertPopupView(headerText: Strings.BluetoothUnavailable.header.uppercased(), primaryColor: .red, content: {
                        Image(systemName: Strings.BluetoothUnavailable.iphoneSlashSymbolName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 48)
                        Text(Strings.BluetoothUnavailable.title.uppercased())
                            .font(Fonts.semibold(size: 22))
                        Text(Strings.BluetoothUnavailable.description.uppercased())
                            .font(Fonts.medium(size: 14))
                            .multilineTextAlignment(.center)
                    })
                    .padding(.horizontal, 8)
                    Spacer()
                }
            }
            .foregroundColor(Colors.primary)
            .onReceive(timer) { _ in
                withAnimation {
                    if variableValue == 1.0 {
                        variableValue = 0.0
                    } else {
                        variableValue += 0.25
                    }
                }
            }
            .onAppear {
                if bluetoothManager.isSwitchedOn {
                    currentState = .ready
                }
            }
            .onChange(of: bluetoothManager.isSwitchedOn) { isOn in
                if isOn {
                    currentState = .ready
                } else {
                    currentState = .unavailable
                }
            }
            .onChange(of: bluetoothManager.isConnected) { connected in
                if connected {
                    currentState = .connected
                }
            }
            .onChange(of: bluetoothManager.peripheral) { peripheral in
                if peripheral != nil {
                    currentState = .found
                }
            }
            .onChange(of: currentState) { newState in
                if newState == .ready {
                    print("Ready")
                    bluetoothManager.stopScanning()
                } else if newState == .searching {
                    print("Searching")
                    bluetoothManager.startScanning()
                }
            }
        }
    }
    
    // MARK: - State management
    private enum BluetoothState {
        case ready, searching, found, connected, unavailable
    }
    
    // MARK: - Sub-views
    private struct HydromonConnectedAnimationView: View {
        private static let fileName = "hydromon-connected"
        private static let fileExtension = "mp4"
        
        @Binding var currentState: BluetoothState
        @State var player = AVPlayer(url: Bundle.main.url(forResource: fileName, withExtension: fileExtension)!)
        
        var body: some View {
            VideoPlayer(player: player)
                .aspectRatio(contentMode: .fit)
                .disabled(true)
                .onChange(of: currentState) { newState in
                    if newState == .connected {
                        player.play()
                    }
                }
        }
    }
    
    private struct EllipsisAnimationView: View {
        private let symbolName = "ellipsis"
        
        @Binding var currentState: BluetoothState
        @Binding var variableValue: Double
        
        var body: some View {
            if currentState == .searching {
                Image(systemName: symbolName, variableValue: variableValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 14)
                    .glow(Colors.primary, intensity: 0.5)
            } else {
                Image(systemName: symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 14)
                    .glow(Colors.primary, intensity: 0.5)
            }
        }
    }
    
    private struct iPhoneRadioWavesAnimationView: View {
        private let staticSymbolName = "iphone.gen3.circle.fill"
        private let variableSymbolName = "iphone.gen3.radiowaves.left.and.right.circle.fill"
        
        @Binding var currentState: BluetoothState
        @Binding var variableValue: Double
        
        var body: some View {
            if currentState == .searching {
                Image(systemName: variableSymbolName, variableValue: variableValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 48)
            } else {
                Image(systemName: staticSymbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 48)
            }
        }
    }
    
    private struct ConnectionPopupView: View {
        @Binding var currentState: BluetoothState
        @Binding var variableValue: Double
        
        let connect: () -> Void
        let dismiss: () -> Void
        
        var body: some View {
            switch currentState {
            case .searching:
                AlertPopupView(
                    headerText: Strings.Searching.header.uppercased(),
                    buttonText: Strings.Searching.button.uppercased()) {
                        currentState = .ready
                    } content: {
                        iPhoneRadioWavesAnimationView(currentState: $currentState, variableValue: $variableValue)
                        Text(Strings.Searching.title.uppercased())
                            .font(Fonts.semibold(size: 22))
                        Text(Strings.Searching.description.uppercased())
                            .font(Fonts.medium(size: 14))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 8)
            case .found:
                AlertPopupView(
                    headerText: Strings.Found.header.uppercased(),
                    buttonText: Strings.Found.button.uppercased()) {
                        connect()
                    } content: {
                        iPhoneRadioWavesAnimationView(currentState: $currentState, variableValue: $variableValue)
                        Text(Strings.Found.title.uppercased())
                            .font(Fonts.semibold(size: 22))
                        Text(Strings.Found.description.uppercased())
                            .font(Fonts.medium(size: 14))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 8)
            case .connected:
                AlertPopupView(
                    headerText: Strings.Connected.header.uppercased(),
                    buttonText: Strings.Connected.button.uppercased()) {
                        dismiss()
                    } content: {
                        iPhoneRadioWavesAnimationView(currentState: $currentState, variableValue: $variableValue)
                        Text(Strings.Connected.title.uppercased())
                            .font(Fonts.semibold(size: 22))
                        Text(Strings.Connected.description.uppercased())
                            .font(Fonts.medium(size: 14))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 8)
            default:
                AlertPopupView(
                    headerText: Strings.Ready.header.uppercased(),
                    buttonText: Strings.Ready.button.uppercased()) {
                        currentState = .searching
                    } content: {
                        iPhoneRadioWavesAnimationView(currentState: $currentState, variableValue: $variableValue)
                        Text(Strings.Ready.title.uppercased())
                            .font(Fonts.semibold(size: 22))
                        Text(Strings.Ready.description.uppercased())
                            .font(Fonts.medium(size: 14))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 8)
            }
        }
    }
}
