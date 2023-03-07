//
//  roomboard.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct roomboard :  Codable, Identifiable {
    let id = UUID()
    let oncampus : Int?
}
