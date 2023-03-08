//
//  AddCommasToNumber.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/7/23.
//

import Foundation

func AddCommasToNumber(var number : Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value:number))
    return "$" + String(formattedNumber?.split(separator: ",")[0] ?? "0") + "k"
}
