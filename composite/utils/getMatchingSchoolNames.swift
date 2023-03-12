//
//  getMatchingSchoolNames.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation

func getMatchingSchoolNames(query: String, minAct: Int, minSAT: Int, adminRate: Double,gradRate: Double,westEnabled : Bool, southEnabled : Bool,midwestEnabled : Bool,northeastEnabled : Bool) -> [institution] {
    var ans : [institution] = []
    if let url = Bundle.main.url(forResource: "colleges", withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let regex = try Regex("(?i)^"+query)
               let jsonData = try decoder.decode([institution].self, from: data)
               for i in jsonData {
                   
                   if (i.School_Name.contains(regex) || getDomainNameFromURL(url: i.Domain_Name).contains(regex) ) {
                       if ((i.adminRate ?? 0) * 100 >= adminRate && (i.gradRate ?? 0) * 100 >= gradRate && i.minACT ?? 0 ?? 0 >= minAct && i.minSAT ?? 0 >= minSAT && getRegionFromStateAbbrev(stateAbbrev: i.state ?? "", westEnabled: westEnabled, southEnabled: southEnabled, midwestEnabled: midwestEnabled, northeastEnabled: northeastEnabled)) {
                           ans.append(i)
                       }
                   } else { // Improve performance of search then implement
                       var a = i.School_Name.split(separator: " ")
                       for a1 in a {
                           if (a1.contains(regex) && ans.filter{$0.School_Name == i.School_Name}.isEmpty) {
                               if (i.adminRate ?? 0 >= adminRate && i.gradRate ?? 0 >= gradRate && i.minACT ?? 0 ?? 0 >= minAct && i.minSAT ?? 0 >= minSAT && getRegionFromStateAbbrev(stateAbbrev: i.state ?? "", westEnabled: westEnabled, southEnabled: southEnabled, midwestEnabled: midwestEnabled, northeastEnabled: northeastEnabled)) {
                                   ans.append(i)
                               }
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
    var a = url.replacingOccurrences(of: "www.", with: "")
    a = a.replacingOccurrences(of:".edu/",with:"")
    a = a.replacingOccurrences(of:"/",with:"")
    a = a.replacingOccurrences(of:"https:",with:"")
    a = a.replacingOccurrences(of:"web.",with:"")
    return a
}

func getDomainNameAndExtensionFromURL (url : String) -> String {
    var a = url.replacingOccurrences(of: "www.", with: "")
    a = a.replacingOccurrences(of:"/",with:"")
    a = a.replacingOccurrences(of:"https:",with:"")
    a = a.replacingOccurrences(of:"web.",with:"")
    return a
}
