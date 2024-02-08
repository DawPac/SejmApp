//
//  Journal.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 31/01/2024.
//

import Foundation

struct Journal: Codable {
    var items: [items]
}

struct items: Codable, Hashable {
    var title: String
    var pos: Int
    var promulgation: String?
}
