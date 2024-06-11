//
//  Mockable.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

protocol Mockable {
    associatedtype MockType
    
    static var mock: MockType { get }
    
    static var mockList: [MockType] { get }
}


extension Mockable {
    static var mockList: [MockType] {
        get { [] }
    }
}
