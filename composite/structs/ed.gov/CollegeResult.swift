//
//  CollegeResult.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

struct CollegeResult :  Codable, Identifiable{
    let id = UUID()
    let latest : latest?
    let location : location?
    let fed_sch_cd : String?
    let school : school?
}
