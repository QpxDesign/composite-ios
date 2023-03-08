//
//  apiCall.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
import SwiftUI
class apiCall {
    func getCollegeData(query : String, completion:@escaping (APICALLResult) -> ()) {
        var r = query.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://api.data.gov/ed/collegescorecard/v1/schools?&api_key=2isPJFEAwppZPL8yc6fmbepPnDRu56bYPyhaBCr0&school_name=\(r)") else {
            print("nerd")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if ((error) != nil) {
                print(error)
                return}
 
            guard  let results =  try? JSONDecoder().decode(APICALLResult.self, from: data!)
            else {
                      print( "error JSONifying data")
                return 
                  }
            
            
            DispatchQueue.main.async {
                completion(results)
            }
            
        }
        .resume()
    }
    func getImageFrom(query : String, completion:@escaping (unsplash_api) -> ()) {
        var q = query.replacingOccurrences(of: " ", with: "%20")
        var a = "https://api.unsplash.com/search/photos?query=\(q)&client_id=pys4HXJeuKmTx8wPnHONDKLkPZTfXwfNJdR_EnGMWJI"
        print(a)
        guard let url = URL(string: a) else {
            print("error creating url")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if ((error) != nil) {
                print(error)
                return}
 
            guard  let results =  try? JSONDecoder().decode(unsplash_api.self, from: data!)
            else {
                      print( "error JSONifying data")
                return
                  }
            
            
            DispatchQueue.main.async {
                completion(results)
            }
            
        }
        .resume()
    }
    func getWeatherNormalsFromStationName(station_Name: String, completion:@escaping ([MonthWeatherNormal]) -> ()) {
        
        var a = "https://www.ncei.noaa.gov/access/services/data/v1?dataset=normals-monthly-2006-2020&stations=USC00210018&format=json&dataTypes=MLY-TMAX-NORMAL,MLY-TMIN-NORMAL,MLY-TAVG-NORMAL,MLY-PRCP-NORMAL,MLY-SNOW-NORMAL"
        guard let url = URL(string: a) else {
            print("error creating url")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if ((error) != nil) {
                print(error)
                return}
            guard  let results =  try? JSONDecoder().decode([MonthWeatherNormal].self, from: data!)
            else {
                print("results")
                print( "error JSONifying data")
                return
            }

            
            
            DispatchQueue.main.async {
                completion(results)
            }
            
        }
        .resume()
    }
}
