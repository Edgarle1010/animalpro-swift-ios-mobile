//
//  DefaultError.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

struct DefaultError: Codable, Equatable {
    var status: Int? = nil
    var response: Bool = false
    var message: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case status, response, message
    }
    
    static func == (lhs: DefaultError, rhs: DefaultError) -> Bool {
        return lhs.status == rhs.status &&
        lhs.response == rhs.response &&
        lhs.message == rhs.message
    }
}
