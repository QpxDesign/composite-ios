//
//  latest.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct latest :  Codable, Identifiable {
    let id = UUID()
    let student : student?
    let cost : cost?
    let completion : completion?
    let admissions : admissions?

}
