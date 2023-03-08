//
//  getClosestWeatherStation.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/7/23.
//

import Foundation
import CoreLocation

func getClosestWeatherStation(location : CLLocation) -> String {
    var ans : String = ""
    var currentClosestDistance : Double = 40000
    if let url = Bundle.main.url(forResource: "weather-stations", withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let jsonData = try decoder.decode([weather_station].self, from: data)
               for i in jsonData {
                   var l1 : CLLocation = CLLocation(latitude: i.lat ?? 0, longitude: i.lon ?? 0)
                   if (l1.distance(from: location) < currentClosestDistance) {
                       ans = i.station_name ?? "";
                       currentClosestDistance = l1.distance(from: location);
                   }
           
               }
            
           } catch {
               print("error:\(error)")
           }
       }
    return ans
}
