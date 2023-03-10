//
//  SignupResponse.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/9/23.
//

import Foundation
struct SignupResponse :  Codable, Identifiable {
    let id = UUID()
    let status: String?
    let ERROR_FOUND : Bool?
    let ERROR_MESSAGE : String?
    let token : String?
}
