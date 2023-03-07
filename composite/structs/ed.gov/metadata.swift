//
//  metadata.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct metadata :  Codable, Identifiable {
    let id = UUID()
    let page : Int?
    let total : Int?
    let per_page : Int?
}
