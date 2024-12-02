//
//  stringTreatment.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 01/12/24.
//

import Foundation

func stringTreatment(for text: String) -> String {
    
    let string = text.split(separator: "")
    var treated: String = ""
    
    for i in string {
        
        if(i != " ") {
            treated += i
            treated += "\n"
        } else {
            treated += "\n\n"
        }
        
    }
    
    return treated
    
}
