//
//  PrintsView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 17/01/2024.
//

import SwiftUI

struct PrintsView: View {
    
    @State var prints:[Print] = []
    @State var search:String = ""
    @State var listItems:[listItem] = []

    var searchResults: [listItem] {
        if search.isEmpty {
            return listItems
        } else {
            return listItems.filter { "\($0.key)".lowercased().contains(search.lowercased()) }
        }
    }
    
    func loadPrints() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/sejm/term10/prints")!)
            prints = try JSONDecoder().decode([Print].self, from: data)
            for i in prints {
                listItems.append(listItem(key: "print \(i.number): \(i.title)", value: "", child: [listItem(key: "attachments", value: "", child: []), listItem(key: "date:", value: i.deliveryDate)]))
                for j in i.attachments {
                    if (j.contains(".pdf")) {
                        listItems[listItems.count-1].child![0].child?.append(listItem(key: "filename", value: j))
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    var body: some View {
        NavigationView {
            List (searchResults.reversed(), children: \.child) { row in
                HStack {
                    Text(row.key)
                    Spacer()
                    if (row.key == "filename") {
                        Link("\(row.value)", destination: URL(string: "https://api.sejm.gov.pl/sejm/term10/prints/\(row.value.split(separator: ".")[0])/\(row.value)")!)
                    } else {
                        Text(row.value)
                    }
                }
            }
            .navigationTitle("prints")
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .autocorrectionDisabled(true)
        .refreshable {
            await loadPrints()
        }
        .task {
            if (prints.isEmpty) {
                await loadPrints()
            }
        }
    }
}
/*
#Preview {
    PrintsView()
}
*/
