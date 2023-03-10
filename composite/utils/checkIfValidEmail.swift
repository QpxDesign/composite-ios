//
//  checkIfValidEmail.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/9/23.
//

import Foundation

func checkIfValidEmail(email : String) -> Bool {
    let regex = (try! Regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"))

    return email.contains(regex)
}
