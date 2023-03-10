//
//  institution.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct institution :  Codable, Identifiable {
    let id = UUID()
    let School_Name : String
    let Domain_Name : String
}
