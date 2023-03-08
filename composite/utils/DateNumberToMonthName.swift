//
//  dnNumberToMonthName.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/7/23.
//

import Foundation

func DateNumberToMonthName(dn : Int) -> String {
    if (dn == 1) {return "Jan"}
    if (dn == 2) {return "Feb"}
    if (dn == 3) {return "Mar"}
    if (dn == 4) {return "Apr"}
    if (dn == 5) {return "May"}
    if (dn == 6) {return "Jun"}
    if (dn == 7) {return "Jul"}
    if (dn == 8) {return "Aug"}
    if (dn == 9) {return "Sep"}
    if (dn == 10) {return "Oct"}
    if (dn == 11) {return "Nov"}
    if (dn == 12) {return "Dec"}
    return ""
}
