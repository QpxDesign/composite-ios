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
                   
                   if (i.School_Name.contains(regex) || getDomainNameFromURL(url: i.Domain_Name).contains(regex) ) {
                       ans.append(i)
                   } else { // Improve performance of search then implement
                       var a = i.School_Name.split(separator: " ")
                       for a1 in a {
                           if (a1.contains(regex) && ans.filter{$0.School_Name == i.School_Name}.isEmpty) {
                               ans.append(i)
                           }
                       }
                     
                   }
           
               }
            
           } catch {
               print("error:\(error)")
           }
       }
    return ans
}

func getDomainNameFromURL (url : String) -> String {
    print(String(url))
    var a = url.replacingOccurrences(of: "www.", with: "")
    a = a.replacingOccurrences(of:".edu/",with:"")
    a = a.replacingOccurrences(of:"/",with:"")
    a = a.replacingOccurrences(of:"https:",with:"")
    a = a.replacingOccurrences(of:"web.",with:"")
    return a
}
