//
//  unsplash_user.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct unsplash_user :  Codable, Identifiable {
    let id = UUID()
    let username : String?
}
