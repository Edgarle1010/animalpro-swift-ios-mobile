//
//  LoginService.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

enum LoginService: APIConfiguration {
    case refreshToken(payload: RefreshTokenPayload)
    
    var method: HTTPMethod {
        switch self {
        case .refreshToken:
            return .post
        }
    }

    var path: String {
        switch self {
        case .refreshToken:
            return K.EndPoints.Auth.refreshToken
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .refreshToken:
            return nil
        }
    }

    var body: Data? {
        switch self {
        case .refreshToken(let payload):
            return try! JSONEncoder().encode(payload)
        }
    }

    var host: String {
        switch self {
        case .refreshToken:
            return K.Host.baseUrl
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        do {
            var url = try host.asURL()
            url.appendPathComponent(path)
            var request = URLRequest(url: url)
            if let body = body {
                request.httpBody = body
            }
            request.httpMethod = method.rawValue
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return request
        } catch {
            print(error)
            return URLRequest(url: URL(string: "wwww.google.com")!)
        }
    }
}
