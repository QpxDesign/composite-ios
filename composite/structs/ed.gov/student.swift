//
//  student.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct student :  Codable, Identifiable {
    let id = UUID()
    let size : Int?
    let grad_students : Int?
    let enrollment : enrollment?
    let demographics : demographics?
}
