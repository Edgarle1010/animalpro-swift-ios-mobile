//
//  BuildConfiguration.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var environment: BuildEnvironment
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        print(currentConfiguration)
        environment = BuildEnvironment(rawValue: currentConfiguration)!
    }
}
