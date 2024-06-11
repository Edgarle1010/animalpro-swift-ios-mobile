//
//  K.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

struct K {
    enum EndPoints {
        enum Auth {
            static let refreshToken = "auth/refresh"
        }
    }
    
    enum Host {
        static var baseUrl: String {
            switch BuildConfiguration.shared.environment {
            case .debugDevelopment, .releaseDevelopment:
                return "https://api-dev"
            case .debugQA, .releaseQA:
                return "https://api-qa"
            case .debugUAT, .releaseUAT:
                return "https://api-uat"
            case .debugProduction, .releaseProduction:
                return "https://api-production"
            }
        }
    }
    
    enum App {
        static let name = "AnimalPro"
    }
}
