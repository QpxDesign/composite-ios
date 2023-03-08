//
//  unsplash_api.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct unsplash_api  : Codable, Identifiable {
    let id = UUID()
    let results : [unsplash_results]?
}
