//
//  ListItem.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 23/01/2024.
//

import Foundation

struct listItem: Identifiable {
    var id = UUID()
    var key: LocalizedStringResource
    var value: String
    var child: [listItem]?
}
