//
//  demographics.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct demographics :  Codable, Identifiable {
    let id = UUID()
    let men: Double?
    let women: Double?
    let race_ethnicity: race_ethnicity?
}
