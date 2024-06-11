//
//  BuildEnvironment.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

enum BuildEnvironment: String {
    case debugDevelopment = "Debug Development"
    case releaseDevelopment = "Release Development"
    
    case debugQA = "Debug QA"
    case releaseQA = "Release QA"
    
    case debugUAT = "Debug UAT"
    case releaseUAT = "Release UAT"
    
    case debugProduction = "Debug"
    case releaseProduction = "Release"
}
