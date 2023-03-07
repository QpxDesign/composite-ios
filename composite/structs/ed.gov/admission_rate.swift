//
//  admission_rate.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct admission_rate : Codable, Identifiable {
    let id = UUID()
    let overall : Float?
}
