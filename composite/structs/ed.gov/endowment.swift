//
//  endowment.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct endowment :  Codable, Identifiable {
    let id = UUID()
    let end : Int?
    let begin : Int?
}

