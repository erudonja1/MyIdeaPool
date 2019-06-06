//
//  NetworkManager.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager: SessionManager{
    
    // MARK: - Singleton instance
    static let shared: Alamofire.SessionManager = {
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Content-Type"] = "application/json"
        defaultHeaders["Accept"] = "application/json"
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.timeoutIntervalForRequest = 10
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        let oauthHandler = AuthorizationService()
        
        sessionManager.adapter = oauthHandler
        sessionManager.retrier = oauthHandler
        
        return sessionManager
    }()
}
