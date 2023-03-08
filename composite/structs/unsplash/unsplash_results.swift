//
//  unsplash_results.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct unsplash_results :  Codable, Identifiable {
    let id = UUID()
    let alt_description : String?
    let urls : unsplash_urls?
    let unsplash_user : unsplash_user?
    
}

