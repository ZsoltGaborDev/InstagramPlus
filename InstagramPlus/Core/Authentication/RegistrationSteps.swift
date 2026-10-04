//
//  RegistrationSteps.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 04/10/2026.
//

import Foundation

enum RegistrationSteps: Int {
    case email
    case username
    case password
    
    case completion
}

extension RegistrationSteps: Identifiable, Hashable {
    var id: Int { self.rawValue }
}
