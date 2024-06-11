//
//  APIResponse.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    var response: Bool
    var message : String?
    var status : Int
    var data: T?
}
