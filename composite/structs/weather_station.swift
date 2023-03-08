//
//  weather_station.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/7/23.
//

import Foundation
struct weather_station :  Codable, Identifiable {
    let id = UUID()
    let station_name: String?
    let lat : Double?
    let lon : Double?
}
