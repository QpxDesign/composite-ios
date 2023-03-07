//
//  midpointACT.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct midpointACT :  Codable, Identifiable  {
    let id = UUID()
    let math : Int?
    let english : Int?
    let writing : Int?
    let cumulative : Int?
}
