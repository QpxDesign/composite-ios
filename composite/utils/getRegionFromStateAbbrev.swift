//
//  getRegionFromStateAbbrev.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/11/23.
//

import Foundation

func getRegionFromStateAbbrev(stateAbbrev : String, westEnabled : Bool, southEnabled : Bool,midwestEnabled : Bool,northeastEnabled : Bool) -> Bool {
    var west : [String] = ["CA","OR","WA","NV","AZ","UT","ID","MT","NM","WY","HI","AK"]
    var midwest : [String] = ["ND","SD","NE","KS","MN","IA","MO","WI","IL","IN","OH","MI","OH"]
    var south : [String] = ["OK","AR","LA","MS","TX","AL","GA","FL","SC","NC","TN","VA","KY","WV"]
    var northeast : [String] = ["ME","VT","NH","MA","RI","CT","NJ","DE","MD","DC","PA","NY"]
    print(west.count+midwest.count+south.count+northeast.count)
    if (westEnabled && !west.filter{$0 == stateAbbrev}.isEmpty) {return true}
    if (midwestEnabled && !midwest.filter{$0 == stateAbbrev}.isEmpty) {return true}
    if (southEnabled && !south.filter{$0 == stateAbbrev}.isEmpty) {return true}
    if (northeastEnabled && !northeast.filter{$0 == stateAbbrev}.isEmpty) {return true}

    return false
}
