//
//  Live.swift
//  SejmApp
//
//  Created by Dawid Paćkowski on 25/01/2024.
//

import Foundation

struct Live: Decodable, Hashable {
    var otherVideoLinks: [String]?
    var room: String
    var videoLink: String
}
