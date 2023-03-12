//
//  getLoadingDots.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/12/23.
//

import Foundation

func getLoadingDots(TimerInterval : Int) -> String {
    if (TimerInterval == 1){ return "."}
    if (TimerInterval == 2) {return ".."}
    if (TimerInterval == 3){ return "..."}
    return ""
    
}
