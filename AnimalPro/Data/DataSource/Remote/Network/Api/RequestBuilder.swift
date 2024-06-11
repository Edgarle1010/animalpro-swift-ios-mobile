//
//  RequestBuilder.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

protocol RequestBuilder {
    func asURLRequest() throws -> URLRequest
}

extension RequestBuilder {
    public var urlRequest: URLRequest? { try? asURLRequest() }
    
}

protocol APIConfiguration: RequestBuilder {
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
    var host: String{ get }
}


public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
