//
//  tuition.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct tuition :  Codable, Identifiable {
    let id = UUID()
    let in_state : Int?
    let out_of_state : Int?
}
