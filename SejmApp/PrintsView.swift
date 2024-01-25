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
    @State var showPDF = UserDefaults.standard.bool(forKey: "show-pdf")
    
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
                listItems.append(listItem(key: "print \(i.number): \(i.title)", value: "", child: [listItem(key: "open", value: "https://api.sejm.gov.pl/sejm/term10/prints/\(i.number)/\(i.number).pdf"), listItem(key: "date:", value: i.deliveryDate)]))
            }
        } catch {
            print("error")
        }
    }
    
    var body: some View {
        NavigationView {
            List (searchResults.reversed(), children: \.child) { row in
                HStack {
                    if (row.key == "open") {
                        if (showPDF) {
                            NavigationLink("\(row.key)"){CustomPDFView(PDFUrl: "\(row.value)")}
                        } else {
                            Link("\(row.key)", destination: URL(string: row.value)!)
                        }
                    } else {
                        Text(row.key)
                        Spacer()
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
