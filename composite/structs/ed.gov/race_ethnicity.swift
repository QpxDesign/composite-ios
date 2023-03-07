//
//  race_ethnicity.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct race_ethnicity :  Codable, Identifiable {
    let id=UUID()
    let aian: Double?
    let nhpi: Double?
    let asian: Double?
    let black: Double?
    let white: Double?
    let unknown: Double?
}
