//
//  school.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
struct school :  Codable, Identifiable {
    let id = UUID()
    let zip: String?
    let city : String?
    let name : String?
    let alias : String?
    let state : String?
    let locale : Int?
    let dolflag : Int?
    let branches : Int?
    let men_only : Int?
    let operating : Int?
    let ownership : Int?
    let region_id : Int?
    let accreditor : String?
    let school_url : String?
    let state_fips : Int?
    let women_only : Int?
    let main_campus: Int?
    let online_only : Int?
    let endowment : endowment?
    let carnegie_basic: Int?
    let faculty_salary: Int?
    let ownership_peps: Int?
    let accreditor_code: String?
    let ft_faculty_rate: Double?
    let carnegie_undergrad: Int?
    let degree_urbanization: Int?
    let under_investigation: Int?
    let price_calculator_url: String?
    let carnegie_size_setting: Int?
    func hash(into hasher: inout Hasher) {
    }
}
