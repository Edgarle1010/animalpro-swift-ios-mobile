//
//  NetworkAssemby.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation
import Swinject

class NetworkAssemby: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(APIService.self) { r in
            APISession()
        }
    }
}
