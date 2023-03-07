//
//  cost.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct cost :  Codable, Identifiable {
    let id = UUID()
    let tuition : tuition?
    let roomboard : roomboard?
    let avg_net_price : avg_net_price?
}
