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
    
    var searchResults: [Print] {
        if search.isEmpty {
            return prints
        } else {
            return prints.filter { $0.title.lowercased().contains(search.lowercased()) || String($0.number) == search}
        }
    }
    
    func loadPrints() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/sejm/term10/prints")!)
            prints = try JSONDecoder().decode([Print].self, from: data)
        } catch {
            print("error")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults.reversed(), id: \.self) {print in
                    NavigationLink("print \(print.number) - \(print.title)") { CustomPDFView(PDFUrl: "https://api.sejm.gov.pl/sejm/term10/prints/\(print.number)/\(print.attachments[0])") }
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
