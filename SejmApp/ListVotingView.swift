//
//  ListVotingView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 18/01/2024.
//

import SwiftUI

struct ListVotingView: View {
    
    @State var vote:Vote
    
    var body: some View {
        List {
            Text(vote.title + " - " + (vote.topic ?? ""))
            Text(vote.date.replacing("T", with: " "))
            Chart {
                ForEach(vote.votingOptions!, id: \.self) { option in
                    BarMark(x: .value("type", option.option), y: .value("votes-num", option.votes))
                        .foregroundStyle(option.votes > vote.totalVoted/2 ? .green : .red)
                }
            }
            .chartYAxis(.hidden)
            .padding()
            ForEach(vote.votingOptions!, id: \.self) { option in
                Text(option.option+": "+String(option.votes))
            }
            Text("abstain: \(vote.abstain)")
        }
    }
}
/*
#Preview {
    ListVotingView()
}
*/
