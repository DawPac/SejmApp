//
//  DUView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 31/01/2024.
//

import SwiftUI

struct DUView: View {
    
    @State var selectedYear:Int = 2024
    let years = Array(1977...2024)
    @State var selectedJournal:String = "Dziennik Ustaw"
    @State var selectedJournalShort:String = "DU"
    let journals:[String] = ["Dziennik Ustaw", "Monitor Polski"]
    @State var journalsDecoded:Journal = Journal(items: [])
    @State var listItems:[listItem] = []
    @State var showPDF = UserDefaults.standard.bool(forKey: "show-pdf")
    @State var search:String = ""

    var searchResults: [listItem] {
        if search.isEmpty {
            return listItems
        } else {
            return listItems.filter { "\($0.key)".lowercased().contains(search.lowercased()) }
        }
    }
    
    func loadJournals() async {
        listItems = []
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/eli/acts/\(selectedJournalShort)/\(selectedYear)")!)
            journalsDecoded = try JSONDecoder().decode(Journal.self, from: data)
            for i in journalsDecoded.items {
                listItems.append(listItem(key: "\(i.pos). \(i.title)", value: "", child: [listItem(key: "open", value: "https://api.sejm.gov.pl/eli/acts/\(selectedJournalShort)/\(selectedYear)/\(i.pos)/text.pdf"), listItem(key: "date:", value: i.promulgation ?? "")]))
            }
        } catch {
            print("error")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List (searchResults.reversed(), children: \.child) { row in
                    HStack {
                        if (row.key == "open") {
                            if (showPDF) {
                                NavigationLink("\(row.key)"){CustomPDFView(PDFUrl: "\(row.value)")}
                            } else {
                                Link("\(row.key)", destination: URL(string: row.value)!)
                                    .foregroundStyle(.link)
                            }} else {
                            Text(row.key)
                            Spacer()
                            Text(row.value)
                        }
                    }
                }
            }
            .navigationTitle("du")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text("\(year)")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Picker("", selection: $selectedJournal) {
                        ForEach(journals, id: \.self) { journal in
                            Text(journal)
                        }
                    }
                }
            }
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .autocorrectionDisabled(true)
        .refreshable {
            await loadJournals()
        }
        .task {
            if (listItems.isEmpty) {
                await loadJournals()
            }
        }
        .onChange(of: selectedYear) {
            Task { await loadJournals() }
        }
        .onChange(of: selectedJournal) {
            if (selectedJournal == "Dziennik Ustaw") {
                selectedJournalShort = "DU"
            }
            if (selectedJournal == "Monitor Polski") {
                selectedJournalShort = "MP"
            }
            Task { await loadJournals() }
        }
    }
}

#Preview {
    DUView()
}
