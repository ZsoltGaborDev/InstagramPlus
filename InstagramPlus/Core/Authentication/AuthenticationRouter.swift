//
//  AuthenticationRouter.swift
//  InstagramPlus
//
//  Created by Zsolt Gabor on 04/10/2026.
//

import Foundation

@Observable
class AuthenticationRouter {
    var navigationPath = [RegistrationSteps]()
    
    private(set) var currentStep: RegistrationSteps?
    
    func startRegostration() {
        guard let initialStep = RegistrationSteps.init(rawValue: 0) else { return }
        navigationPath.append(initialStep)
        currentStep = initialStep
    }
    
    func navigate() {
        self.currentStep = navigationPath.last
        
        guard let index = currentStep?.rawValue else { return }
        guard let nextStep = RegistrationSteps.init(rawValue: index + 1) else { return }
        
        navigationPath.append(nextStep)
    }
    
    func reset() {
        navigationPath.removeAll()
        currentStep = nil
    }
}
