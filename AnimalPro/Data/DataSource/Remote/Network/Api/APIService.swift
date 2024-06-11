//
//  APIService.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation
import Combine

protocol APIService {
    func request<T: Decodable, E: Codable>(with builder: RequestBuilder, retryRefreshToken: Bool) -> AnyPublisher<T, APIError<E>>
    func awaitRequest<T: Decodable, E: Codable>(with builder: RequestBuilder) async -> Result<T, APIError<E>>
}
