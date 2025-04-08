//
//  String+.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/3/24.
//

import Foundation
extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + self.dropFirst()
    }
    
    var seperateUpperLetter: String {
        return self.reduce("", { $0 + ($1.isUppercase ? "_\($1.lowercased())" : "\($1)" )})
    }
    
    
}
