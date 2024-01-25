//
//  LiveView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 25/01/2024.
//

import SwiftUI
import AVKit

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct LiveView: View {
    
    func loadURLs() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/sejm/term10/videos/today")!)
            lives = try JSONDecoder().decode([Live].self, from: data)
            for i in lives {
                if (i.room == "Sala Posiedzeń") {
                    players.append(AVPlayer(url: URL(string: i.videoLink.split(separator: "?")[0].replacing("nvr", with: "livehls").replacing("http://", with: "https://")+"/playlist.m3u8")!))
                    if (i.otherVideoLinks != nil) {
                        for j in i.otherVideoLinks! {
                            players.append(AVPlayer(url: URL(string: j.split(separator: "?")[0].replacing("nvr", with: "livehls").replacing("http://", with: "https://").replacing(" ", with: "")+"/playlist.m3u8")!))
                        }
                    }
                }
            }
            for i in players {
                i.volume = 0
                i.play()
            }
            players[0].volume = 1
        } catch {
            print("error")
        }
    }
    
    @State var lives:[Live] = []
    @State var players:[AVPlayer] = []
    @State var orientation = UIDeviceOrientation.unknown

    var body: some View {
        NavigationView {
            if (!players.isEmpty) {
                if (!orientation.isLandscape) {
                    VStack {
                        ForEach(Range(0...players.count - 1), id: \.self) {index in
                            if (index < 3) {
                                CustomPlayerView(player: players[index])
                            }
                        }
                    }
                } else {
                    HStack {
                        VStack {
                            ForEach(Range(0...players.count - 1), id: \.self) {index in
                                if (index < 2) {
                                    CustomPlayerView(player: players[index])
                                }
                            }
                        }
                        VStack {
                            ForEach(Range(0...players.count - 1), id: \.self) {index in
                                if (index > 1 && index < 4) {
                                    CustomPlayerView(player: players[index])
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await loadURLs()
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

struct CustomPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomPlayerView>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<CustomPlayerView>) {
        
    }
}
/*
#Preview {
    LiveView()
}
*/
