//
//  APICallResult.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct APICALLResult :  Codable, Identifiable {
    let id = UUID()
    let metadata: metadata?
    let results : [CollegeResult]?
}
