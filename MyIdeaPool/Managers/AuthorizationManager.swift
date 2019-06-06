//
//  AuthorizationManager.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation

class AuthorizationManager{
    
    // MARK: Token handling
    var token: String {
        get{
            return UserDefaults.standard.string(forKey: "token") ?? ""
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    var refreshToken: String {
        get{
            return UserDefaults.standard.string(forKey: "refresh_token") ?? ""
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: "refresh_token")
        }
    }
    
    var userId: Int {
        get{
            return UserDefaults.standard.integer(forKey: "app_user_id")
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: "app_user_id")
        }
    }
    
    static let shared: AuthorizationManager = AuthorizationManager()
    
    func isLoggedIn() -> Bool{
        return !(token.isEmpty)
    }
    
    // MARK: - public Authorization setter
    func resetAuthorization(authorization auth: ApiUserAuthorized){
        self.token = auth.accessToken
        self.refreshToken = auth.refreshToken
        let oauthService = AuthorizationService()
        ApiManager.shared.adapter = oauthService
        ApiManager.shared.retrier = oauthService
    }
    
    func resetAuthorization(refreshedAuthorization refreshedAuth: ApiUserTokenRefreshed){
        self.token = refreshedAuth.access_token
        let oauthService = AuthorizationService()
        ApiManager.shared.adapter = oauthService
        ApiManager.shared.retrier = oauthService
    }
}
