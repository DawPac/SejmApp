//
//  VotesView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 17/01/2024.
//

import SwiftUI

struct VotesView: View {
    
    @State var votes:[[Vote]] = []
    @State var listItems:[listItem] = []
    @State var search:String = ""
    
    var searchResults: [listItem] {
        if search.isEmpty {
            return listItems
        } else {
            var returnValue: [listItem] = []
            for i in Range(0...listItems.count-1) {
                returnValue += (listItems[i].child?.filter { "\($0)".lowercased().contains(search.lowercased()) })!
            }
            return returnValue
        }
    }
    
    func loadVotes() async {
        votes = []
        listItems = []
        var sitting:Int = 1
        while(true) {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/sejm/term10/votings/\(sitting)")!)
                if (String(data: data, encoding: .utf8) == "[]") {
                    break
                }
                votes.append(try! JSONDecoder().decode([Vote].self, from: data))
                var rowItems:[listItem] = []
                for i in votes[sitting-1] {
                    rowItems.append(listItem(key: "\(i.title) - \(i.topic ?? "")", value: "\(i.kind) \(i.sitting) \(i.votingNumber)"))
                }
                listItems.append(listItem(key: "sitting \(sitting)", value: "", child: rowItems))
                sitting += 1
            } catch {
                print("invalid data")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List (searchResults.reversed(), children: \.child) { row in
                if (row.value.isEmpty) {
                    Text(row.key)
                } else {
                    if (row.value.split(separator: " ")[0] == "ELECTRONIC") {
                        NavigationLink("\(row.key)") { ElecVotingView(vote: votes[Int(row.value.split(separator: " ")[1])! - 1][Int(row.value.split(separator: " ")[2])! - 1]) }
                    } else {
                        NavigationLink("\(row.key)") { ListVotingView(vote: votes[Int(row.value.split(separator: " ")[1])! - 1][Int(row.value.split(separator: " ")[2])! - 1]) }
                    }
                }
            }
            .navigationTitle("votes")
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .autocorrectionDisabled(true)
        .refreshable {
            await loadVotes()
        }
        .task {
            if (votes.isEmpty) {
                await loadVotes()
            }
        }
    }
}
/*
#Preview {
    VotesView()
}
*/
