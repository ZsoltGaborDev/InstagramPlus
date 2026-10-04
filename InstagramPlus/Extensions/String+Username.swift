//
//  String+Username.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 03/10/2026.
//

import Foundation

extension String {
    func isValidUsername() -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let userPredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return userPredicate.evaluate(with: self)
    }
}
