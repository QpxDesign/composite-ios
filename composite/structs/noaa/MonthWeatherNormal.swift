//
//  MonthWeatherNormal.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/7/23.
//

import Foundation
struct MonthWeatherNormal  :  Codable, Identifiable {
    let id = UUID()
    let DATE: String?
    let MLY_TAVG_NORMAL: String?
    let MLY_TMIN_NORMAL: String?
    let STATION: String?
    let MLY_PRCP_NORMAL: String?
    let MLY_TMAX_NORMAL: String?
    let MLY_SNOW_NORMAL : String?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case DATE = "DATE"
        case MLY_TAVG_NORMAL = "MLY-TAVG-NORMAL"
        case MLY_TMIN_NORMAL = "MLY-TMIN-NORMAL"
        case STATION = "STATION"
        case MLY_PRCP_NORMAL = "MLY-PRCP-NORMAL"
        case MLY_TMAX_NORMAL = "MLY-TMAX-NORMAL"
        case MLY_SNOW_NORMAL = "MLY-SNOW-NORMAL"
       }
}


