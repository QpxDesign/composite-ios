//
//  apiCall.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
import SwiftUI
class apiCall {
    func getCollegeData(query : String, domain_name : String, completion:@escaping (CollegeResult) -> ()) {
        var r = query.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://api.data.gov/ed/collegescorecard/v1/schools?&api_key=2isPJFEAwppZPL8yc6fmbepPnDRu56bYPyhaBCr0&school_name=\(r)") else {
            print("nerd")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if ((error) != nil) {
                print(error)
                return}
 
            let t = try! JSONDecoder().decode(APICALLResult.self, from: data!)

            guard  let results =  try? JSONDecoder().decode(APICALLResult.self, from: data!)
                    
            else {

                      print( "error JSONifying data within getCollegeData")
                print("Error info: \(error)")

                return 
                  }
            
            
            DispatchQueue.main.async {
                results.results?.forEach { r in
                    if (r.school?.school_url == domain_name) {
                        completion(r)
                    }
                        
                    
                }
                
            }
            
        }
        .resume()
    }
    func getImageFrom(query : String, completion:@escaping (unsplash_api) -> ()) {
        var q = query.replacingOccurrences(of: " ", with: "%20")
        var a = "https://api.unsplash.com/search/photos?query=\(q)&client_id=pys4HXJeuKmTx8wPnHONDKLkPZTfXwfNJdR_EnGMWJI"
        guard let url = URL(string: a) else {
            print("error creating url")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if ((error) != nil) {
                print(error)
                return}
 
            guard  let results =  try? JSONDecoder().decode(unsplash_api.self, from: data!)
            else {
                print( "error JSONifying data within unsplash")
                return
                  }
            
            
            DispatchQueue.main.async {
                completion(results)
            }
            
        }
        .resume()
    }
    func getWeatherNormalsFromStationName(station_Name: String, completion:@escaping ([MonthWeatherNormal]) -> ()) {
        
        var a = "https://www.ncei.noaa.gov/access/services/data/v1?dataset=normals-monthly-2006-2020&stations=\(station_Name)&format=json&dataTypes=MLY-TMAX-NORMAL,MLY-TMIN-NORMAL,MLY-TAVG-NORMAL,MLY-PRCP-NORMAL,MLY-SNOW-NORMAL"
        guard let url = URL(string: a) else {
            print("a")
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
                print("fired getweather")
                completion(results)
            }
            
        }
        .resume()
    }
    func handleLogin(email : String, password: String, completion:@escaping (LoginResponse) -> ()) {
        guard let url = URL(string: "https://www.composite-api.quinnpatwardhan.com/login") else {
            print("error creating url")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // prepare json data
        let parameters: [String: Any] = ["email": email,"password": password]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((error) != nil) {
                print(error)
                return}
            guard  let results =  try? JSONDecoder().decode(LoginResponse.self, from: data!)
            else {
                print( "error JSONifying data")
                return
            }
            DispatchQueue.main.async {
                completion(results)
                if (!(results.allowLogin ?? false) ) {
                    let defaults = UserDefaults.standard
                    defaults.set(results.token ?? "", forKey: "token")
                    defaults.set(email ?? "", forKey: "email")
                    defaults.set(String(NSDate().timeIntervalSince1970), forKey: "last_login_timestap")
                }
            }
            
        }
        .resume()
    }
    func handleSignup(email : String, password: String, name: String, completion:@escaping (SignupResponse) -> ()) {
        
        guard let url = URL(string: "https://www.composite-api.quinnpatwardhan.com/signup") else {
            print("error creating url")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // prepare json data
        let parameters: [String: Any] = ["email": email,"password": password,"full_name":name]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((error) != nil) {
                print(error)
                return}
            guard  let results =  try? JSONDecoder().decode(SignupResponse.self, from: data!)
            else {
                print( "error JSONifying data")
                return
            }
            DispatchQueue.main.async {
                completion(results)
                if (!(results.ERROR_FOUND ?? false) ) {
                    let defaults = UserDefaults.standard
                    defaults.set(results.token ?? "", forKey: "token")
                    defaults.set(name ?? "", forKey: "full_name")
                    defaults.set(email ?? "", forKey: "email")
                    defaults.set(String(NSDate().timeIntervalSince1970), forKey: "last_login_timestap")
                }
            }
            
        }
        .resume()
    }
    func validateToken(email : String, token: String, completion:@escaping (ValidateTokenResponse) -> ()) {
        
        guard let url = URL(string: "https://www.composite-api.quinnpatwardhan.com/validate-token") else {
            print("error creating url")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // prepare json data
        let parameters: [String: Any] = ["email": email,"token": token]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((error) != nil) {
                print(error)
                return}
            guard  let results =  try? JSONDecoder().decode(ValidateTokenResponse.self, from: data!)
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
    func AddCollegeToFavorites(token: String,collegeID : String, completion:@escaping (GetFavoritesResponse) -> ()) {
        if (collegeID != "") {
            guard let url = URL(string: "https://www.composite-api.quinnpatwardhan.com/add-college-to-favorites") else {
                print("error creating url")
                return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // prepare json data
            let parameters: [String: Any] = ["token": token, "collegeID":collegeID]
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if ((error) != nil) {
                    print(error)
                    return}
                guard  let results =  try? JSONDecoder().decode(GetFavoritesResponse.self, from: data!)
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

    }
    func RemoveCollegeToFavorites(token: String,collegeID : String, completion:@escaping (GetFavoritesResponse) -> ()) {
        
        guard let url = URL(string: "https://www.composite-api.quinnpatwardhan.com/remove-college-from-favorites") else {
            print("error creating url")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // prepare json data
        let parameters: [String: Any] = ["token": token, "collegeID":collegeID]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((error) != nil) {
                print(error)
                return}
            guard  let results =  try? JSONDecoder().decode(GetFavoritesResponse.self, from: data!)
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
    func GetFavoritesFromEmail(email: String, completion:@escaping (GetFavoritesResponse) -> ()) {
        guard let url = URL(string: "https://www.composite-api.quinnpatwardhan.com/get-user-favorites") else {
            print("error creating url")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // prepare json data
        let parameters: [String: Any] = ["email": email]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((error) != nil) {
                print(error)
                return}
            guard  let results =  try? JSONDecoder().decode(GetFavoritesResponse.self, from: data!)
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
    
    func GetCollegeFromID(school_id : String, completion:@escaping (APICALLResult) -> ()) {
        guard let url = URL(string: "https://api.data.gov/ed/collegescorecard/v1/schools?&api_key=2isPJFEAwppZPL8yc6fmbepPnDRu56bYPyhaBCr0&fed_sch_cd=\(school_id)") else {
            print("nerd")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if ((error) != nil) {
                print(error)
                return}
 
            let t = try! JSONDecoder().decode(APICALLResult.self, from: data!)

            guard  let results =  try? JSONDecoder().decode(APICALLResult.self, from: data!)
                    
            else {

                      print( "error JSONifying data within getCollegeData")
                print("Error info: \(error)")

                return
                  }
            
            
            DispatchQueue.main.async {
                completion(results)
            }
            
        }
        .resume()
    }

}
