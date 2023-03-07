//
//  getMatchingSchoolNames.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

func getMatchingSchoolNames(query: String) -> [institution] {
    var ans : [institution] = []
    if let url = Bundle.main.url(forResource: "us_institutions", withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let regex = try Regex("(?i)^"+query)
               let jsonData = try decoder.decode([institution].self, from: data)
               for i in jsonData {
                   
                   if (i.institution.contains(regex)) {
                       ans.append(i)
                   }
           
               }
            
           } catch {
               print("error:\(error)")
           }
       }
    return ans
}
