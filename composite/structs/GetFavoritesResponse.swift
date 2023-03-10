//
//  GetFavoritesResponse.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/9/23.
//

import Foundation
struct GetFavoritesResponse  :  Codable, Identifiable {
    let id = UUID()
    let ids : [String]?
    
}
