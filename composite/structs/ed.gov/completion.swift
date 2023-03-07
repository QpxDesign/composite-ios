//
//  completion.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct completion :  Codable, Identifiable {
    let id = UUID()
    let consumer_rate: Double?
}
