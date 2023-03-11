//
//  ValidateTokenResponse.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/9/23.
//

import Foundation

struct ValidateTokenResponse :  Codable, Identifiable {
    let id = UUID()
    let auth : Bool?
    let full_name : String?
}
