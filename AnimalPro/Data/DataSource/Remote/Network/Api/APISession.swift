//
//  APISession.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation
import Combine

struct APISession: APIService {
    func request<T, E>(with builder: RequestBuilder, retryRefreshToken: Bool = true) -> AnyPublisher<T, APIError<E>> where T: Decodable, E: Codable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        guard let urlRequest = builder.urlRequest else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        printDataRequest(builder: builder)
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { requestError -> APIError<E> in
                if requestError.errorCode == -1009 {
                    return .noInternetConnection
                } else {
                    return .unknown
                }
            }
            .flatMap { data, response -> AnyPublisher<T, APIError<E>> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        
                        printSuccessReponse(data: data)
                        
                        if response.url?.absoluteString.contains("refreshToken") ?? false {
                            do {
                                let response = try decoder.decode(APIResponse<User>.self, from: data)
                                UserSessionData.shared.setUser(user: response.data!)
                                return Fail(error: APIError.tokenRefresh).eraseToAnyPublisher()
                            } catch {
                                print("Error al decodificar response de token")
                                return Fail(error: APIError.unknown).eraseToAnyPublisher()
                            }
                        }
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError { error -> APIError<E> in
                                print(error.localizedDescription)
                                print(String(decoding: data, as: UTF8.self))
                                print(error)
                                return .decodingError
                            }
                            .eraseToAnyPublisher()
                    } else {
                        
                        printErrorData(builder: builder)
                        
                        if (401...404).contains(response.statusCode) {
                            let user = UserSessionData.shared.getUser()
                            if user == nil || (user!.accessToken ?? "").isEmpty {
                                return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
                            } else {
                                if retryRefreshToken {
                                    return refreshToken()
                                } else {
                                    return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
                                }
                            }
                        } else if (500...599).contains(response.statusCode) {
                            return Fail(error: APIError.httpError(response.statusCode)).eraseToAnyPublisher()
                        } else if response.url?.absoluteString.contains("refreshToken") ?? false {
                            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
                        }
                        do {
                            let apiErrorMessage = try decoder.decode(E.self, from: data)
                            return Fail(error: APIError.known(apiErrorMessage)).eraseToAnyPublisher()
                        } catch {
                            return Fail(error: APIError.decodingError).eraseToAnyPublisher()
                        }
                    }
                }
                return Fail(error: APIError.unknown)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func refreshToken<T, E>() -> AnyPublisher<T, APIError<E>> where T: Decodable, E: Codable {
        guard let refreshToken = UserSessionData.shared.getUser()?.refreshToken else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        let payload = RefreshTokenPayload(refreshToken: refreshToken)
        return self.request(with: LoginService.refreshToken(payload: payload), retryRefreshToken: false)
            .flatMap { (response: T) -> AnyPublisher<T, APIError<E>> in
                return Fail(error: APIError.tokenRefresh).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func awaitRequest<T, E>(with builder: RequestBuilder) async -> Result<T, APIError<E>> where T : Decodable, E : Decodable, E : Encodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        guard var request = builder.urlRequest else {
            return .failure(.unknown)
        }
        
        print(request.url ?? "")
        
        if let user = UserSessionData.shared.getUser() {
            request.addValue("Bearer \(user.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.unknown)
            }
            switch response.statusCode {
            case 200...299:
                printSuccessReponse(data: data)
                
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decodingError)
                }
                return .success(decodedResponse)
            case 401:
                let user = UserSessionData.shared.getUser()
                if user == nil || (user!.accessToken ?? "").isEmpty {
                    return .failure(.unauthorized)
                } else {
                    let result = await refreshTokenAwait()
                    switch result {
                    case .success(let apiResponse):
                        UserSessionData.shared.setUser(user: apiResponse.data!)
                        return .failure(.tokenRefresh)
                    case .failure:
                        return .failure(.unauthorized)
                    }
                }
            case 500...599:
                return .failure(.httpError(response.statusCode))
            default:
                do {
                    let apiErrorMessage = try decoder.decode(E.self, from: data)
                    return .failure(.known(apiErrorMessage))
                } catch {
                    print("Error de decoding del error")
                    print("JSON decode error: \(error)")
                    return .failure(.decodingError)
                }
            }
        } catch {
            return .failure(.decodingError)
        }
    }
    
    func refreshTokenAwait() async -> Result<APIResponse<User>, APIError<DefaultError>> {
        guard let user = UserSessionData.shared.getUser() else {
            return .failure(.unknown)
        }
        let payload = RefreshTokenPayload(refreshToken: user.refreshToken ?? "")
        let result: Result<APIResponse<User>, APIError<DefaultError>> = await awaitRequest(with: LoginService.refreshToken(payload: payload))
        return result
    }
}

extension APISession {
    func printDataRequest(builder: RequestBuilder){
        print("<<======================DATA-REQUEST==================================>>")
        print("Url request: \(builder.urlRequest?.url?.absoluteString ?? "")")
        if let headers = builder.urlRequest?.allHTTPHeaderFields {
            print("Headers \n \(headers)")
        }
        print("<<=================================================================>>")
    }
    
    func printSuccessReponse(data: Data){
        print("<<======================SUCCESS-RESPONSE==================================>>")
        let debugData = String(decoding: data, as: UTF8.self)
        Utils.beautifulPrint(debugData)
        print("<<=================================================================>>")
    }
    
    func printErrorData(builder: RequestBuilder){
        print("<<======================API-ERROR==================================>>")
        print("Url: \(builder.urlRequest?.url?.absoluteString ?? "")")
        if let httpBody = builder.urlRequest?.httpBody {
            print("Body:")
            print(String(data: httpBody, encoding: String.Encoding.utf8) as Any)
        }
        if let headers = builder.urlRequest?.allHTTPHeaderFields {
            print("Headers:\(headers)")
        }
        if let method = builder.urlRequest?.httpMethod {
            print("Method:\(method)")
        }
        print("<<=================================================================>>")
    }
}
