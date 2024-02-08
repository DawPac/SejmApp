//
//  ContentView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 17/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            PrintsView().tabItem {
                Label("prints", systemImage: "doc.richtext")
            }
            VotesView().tabItem {
                Label("votes", systemImage: "hand.raised")
            }
            MPView().tabItem {
                Label("mps", systemImage: "person.3")
            }
            DUView().tabItem {
                Label("du", systemImage: "newspaper")
            }
            LiveView().tabItem {
                Label("lives", systemImage: "play.tv")
            }
        }
    }
}

#Preview {
    ContentView()
}
