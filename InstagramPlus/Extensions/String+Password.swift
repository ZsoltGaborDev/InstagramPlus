//
//  String+Password.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 04/10/2026.
//

import Foundation

extension String {
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$@!%&*?])[A-Za-z\\d#$@!%&*?]{8,}$"
        
        return self.range(
            of: passwordRegex,
            options: .regularExpression
        ) != nil
    }
}
