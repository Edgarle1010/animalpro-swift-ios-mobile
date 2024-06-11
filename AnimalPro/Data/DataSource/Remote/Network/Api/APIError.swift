//
//  APIError.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

enum APIError<T: Codable & Equatable>: Error, Equatable {
    case decodingError
    case httpError(Int)
    case unknown
    case known(T)
    case unauthorized
    case tokenRefresh
    case noInternetConnection
    case databaseError(String)
    
    var localizedDescription: String {
        switch self {
        case .decodingError:
            return "Decoding error"
        case .unknown:
            return "Server error unknown"
        case .httpError(let statusCode):
            return "Http Error \(statusCode)"
        case .known(let object):
            return "Error known \(object.toString())"
        case .unauthorized:
            return "Error unauthorized"
        case .tokenRefresh:
            return "Error token refresh"
        case .noInternetConnection:
            return "Error no internet connection"
        case .databaseError(let error):
            return "Database error: \(error)"
            
        }
    }
    
    static func == (lhs: APIError<T>, rhs: APIError<T>) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError),
            (.unknown, .unknown),
            (.unauthorized, .unauthorized),
            (.tokenRefresh, .tokenRefresh),
            (.noInternetConnection, .noInternetConnection):
            return true
        case let (.httpError(statusCode1), .httpError(statusCode2)) where statusCode1 == statusCode2:
            return true
        case let (.known(obj1), .known(obj2)) where obj1 == obj2:
            return true
        case let (.databaseError(error1), .databaseError(error2)) where error1 == error2:
            return true
        default:
            return false
        }
    }
}

public enum NetworkError: Error {
    case invalidURL(url: String)
}
