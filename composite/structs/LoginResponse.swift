//
//  LoginResponse.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/9/23.
//

import Foundation

struct LoginResponse  :  Codable, Identifiable {
    let id = UUID()
    let allowLogin : Bool?
    let token : String?
    
}
