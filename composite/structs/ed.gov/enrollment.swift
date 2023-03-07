//
//  enrollment.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct enrollment :  Codable, Identifiable {
    let id = UUID()
    let grad_12_month : Int?
    let undergrad_12_month : Int?
}
