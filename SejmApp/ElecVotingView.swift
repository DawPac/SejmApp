//
//  ElecVotingView.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 17/01/2024.
//

import SwiftUI

struct ElecVotingView: View {
    
    @State var vote: Vote
    @State var clubs: [String] = []
    @State var clubsVote: [ClubVote] = []
    @Environment(\.horizontalSizeClass) var sizeCategory

    func loadDetails() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.sejm.gov.pl/sejm/term10/votings/\(vote.sitting)/\(vote.votingNumber)")!)
            vote = try JSONDecoder().decode(Vote.self, from: data)
            for i in vote.votes! {
                if (!clubs.contains(i.club)) {
                    clubs.append(i.club)
                    switch (i.vote) {
                    case "YES":
                        clubsVote.append(ClubVote(club: i.club, yes: 1, no: 0, absent: 0, abstain: 0))
                    case "NO":
                        clubsVote.append(ClubVote(club: i.club, yes: 0, no: 1, absent: 0, abstain: 0))
                    case "ABSENT":
                        clubsVote.append(ClubVote(club: i.club, yes: 0, no: 0, absent: 1, abstain: 0))
                        print("test")
                    case "ABSTAIN":
                        clubsVote.append(ClubVote(club: i.club, yes: 0, no: 0, absent: 0, abstain: 1))
                    default:
                        break
                    }
                } else {
                    for j in Range(0...clubsVote.count-1) {
                        if (clubsVote[j].club == i.club) {
                            switch (i.vote) {
                            case "YES":
                                clubsVote[j].yes += 1
                            case "NO":
                                clubsVote[j].no += 1
                            case "ABSTAIN":
                                clubsVote[j].abstain += 1
                                
                            case "ABSENT":
                                clubsVote[j].absent += 1
                            default:
                                break
                            }
                        }
                    }
                }
            }
        } catch {
            print("invalid data")
        }
    }
    
    var body: some View {
        List {
            Text(vote.title + " - " + (vote.topic ?? ""))
            Text(vote.date.replacing("T", with: " "))
            ZStack{
                Path {path in
                    path.move(to: .init(x: 180, y: 180))
                    path.addArc(center: .init(x: 180, y: 180), radius: 150, startAngle: Angle(degrees: 180), endAngle: Angle(degrees:Double(180+(vote.yes*180/vote.totalVoted))), clockwise: false)
                }
                .fill(.green)
                Path {path in
                    path.move(to: .init(x: 180, y: 180))
                    path.addArc(center: .init(x: 180, y: 180), radius: 150, startAngle: Angle(degrees:Double(180+(vote.yes*180/vote.totalVoted))), endAngle: Angle(degrees:Double(180+((vote.no+vote.yes)*180/vote.totalVoted))), clockwise: false)
                }
                .fill(.red)
                if (vote.yes + vote.no != vote.totalVoted) {
                    Path {path in
                        path.move(to: .init(x: 180, y: 180))
                        path.addArc(center: .init(x: 180, y: 180), radius: 150, startAngle: Angle(degrees:Double(180+((vote.no+vote.yes)*180/vote.totalVoted))), endAngle: Angle(degrees:0), clockwise: false)
                    }
                    .fill(.gray)
                }
                Circle()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(.secondarySystemGroupedBackground))
                    .position(x: 180, y: 179)
            }
                .frame(width: 360, height: 200)
            Text("yes: \(vote.yes)")
            Text("no: \(vote.no)")
            Text("abstain: \(vote.abstain)")
            HStack {
                Group {
                    Text("club")
                    Text("yes")
                    Text("no")
                    Text("abstain")
                    Text("absent")
                }
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(Color(.systemGroupedBackground))
            ForEach(clubsVote, id: \.self) { vote in
                HStack {
                    Group {
                        Text(vote.club)
                        Text("\(vote.yes)")
                        Text("\(vote.no)")
                        Text("\(vote.abstain)")
                        Text("\(vote.absent)")
                    }
                    .lineLimit(1)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .task {
            await loadDetails()
        }
    }
}
/*
#Preview {
    ElecVotingView()
}
*/
