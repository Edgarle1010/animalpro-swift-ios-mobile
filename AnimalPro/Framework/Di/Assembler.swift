//
//  Assembler.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation
import Swinject

class IAssembly {
    
    static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler([
            DataSourceAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            NetworkAssemby()
        ], container: container)
        return assembler
    }()
}

infix operator ~>

extension Assembler {
    static func ~> <Service>(assembler: Assembler, serviceType: Service.Type) -> Service? {
        return assembler.resolver.resolve(serviceType)
    }
}
