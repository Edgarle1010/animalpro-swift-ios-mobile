//
//  UserSessionData.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import SwiftUI
import Combine

class UserSessionData: ObservableObject {
    static let shared = UserSessionData()
    
    let defaults = UserDefaults.standard
    
    func setUser(user: User) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            defaults.setValue(jsonData, forKey: defaultsKeys.user)
        } catch {
            print(error)
        }
    }
    
    func getUser() -> User? {
        if let userData = defaults.data(forKey: defaultsKeys.user) {
            do {
                let jsonDecoder = JSONDecoder()
                let user = try jsonDecoder.decode(User.self, from: userData)
                return user
            } catch {
                print(error)
            }
            
        }
        return nil
    }
    
    func deleteUser() {
        defaults.removeObject(forKey: defaultsKeys.user)
    }
    
    @AppStorage(defaultsKeys.accessToken) var accessToken: String = ""
    @AppStorage(defaultsKeys.refreshToken) var refreshToken: String = ""
    @AppStorage(defaultsKeys.firebaseToken) var firebaseToken: String = ""
    @AppStorage(defaultsKeys.isLogged) var isLogged: Bool = false

}

struct defaultsKeys {
    static let user = "comunicaciones_user"
    static let appLanguage = "app_language"
    static let isLogged = "is_logged"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    static let firebaseToken = "firebase_token"
}

