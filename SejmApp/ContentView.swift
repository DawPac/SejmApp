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
            }.tag(1)
            VotesView().tabItem {
                Label("votes", systemImage: "hand.raised")
            }.tag(2)
            MPView().tabItem {
                Label("mps", systemImage: "person.3")
            }.tag(3)
        }
    }
}

#Preview {
    ContentView()
}
