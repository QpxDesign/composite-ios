//
//  location.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct location :  Codable, Identifiable {
    let id = UUID()
    let lat: Double?
    let lon : Double?
}

