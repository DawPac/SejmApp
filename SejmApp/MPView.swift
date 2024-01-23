//
//  MPView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 23/01/2024.
//

import SwiftUI

struct MPView: View {
    
    @State var MPs:[MP] = []
    @State var search:String = ""
    @State var listItems:[listItem] = []
    
    var searchResults: [listItem] {
        if search.isEmpty {
            return listItems
        } else {
            return listItems.filter { "\($0.key)".lowercased().contains(search.lowercased()) }
        }
    }
    
    func loadMPs() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/sejm/term10/MP")!)
            MPs = try JSONDecoder().decode([MP].self, from: data)
            for i in MPs {
                listItems.append(listItem(key: "\(i.firstLastName)", value: "", child: [listItem(key: "birthDate:", value: i.birthDate), listItem(key: "birthLocation:", value: i.birthLocation), listItem(key: "club:", value: i.club), listItem(key: "districtName:", value: i.districtName), listItem(key: "districtNum:", value: String(i.districtNum)), listItem(key: "educationLevel:", value: i.educationLevel), listItem(key: "email:", value: i.email), listItem(key: "numberOfVotes:", value: String(i.numberOfVotes)), listItem(key: "voivodeship:", value: i.voivodeship)]))
            }
        } catch {
            print("error")
        }
    }
    
    var body: some View {
        NavigationStack {
            List (searchResults, children: \.child) { row in
                if (row.key != "email:") {
                    HStack {
                        Text(row.key)
                        Spacer()
                        Text(row.value)
                    }
                }
                if (row.key == "email:") {
                    HStack {
                        Text(row.key)
                        Spacer()
                        Link(row.value, destination: URL(string: "mailto:\(row.value)")!)
                    }
                }
            }
            .navigationTitle("mps")
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .autocorrectionDisabled(true)
        .refreshable {
            await loadMPs()
        }
        .task {
            if (MPs.isEmpty) {
                await loadMPs()
            }
        }
    }
}

#Preview {
    MPView()
}
