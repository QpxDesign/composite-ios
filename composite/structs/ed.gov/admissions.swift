//
//  admissions.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct admissions :  Codable, Identifiable {
    let id = UUID()
    let admission_rate : admission_rate?
    let act_scores : act_scores?
    let sat_scores : sat_scores?
}
