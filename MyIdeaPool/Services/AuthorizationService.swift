//
//  OauthHandlerService.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

// OAuth2 handler
class AuthorizationService: RequestAdapter, RequestRetrier {
    
    private let lock: NSLock = NSLock()
    private let baseURLString: String
    private var refreshTokenUrl: String
    private var isRefreshing: Bool = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    // MARK: - Initialization
    
    public init() {
        self.baseURLString = BaseConfiguration.shared.url
        self.refreshTokenUrl = "\(baseURLString)/access-tokens/refresh"
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            urlRequest.setValue(AuthorizationManager.shared.token, forHTTPHeaderField: "x-access-token")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse{
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] userAuthorized in
                    
                    guard let strongSelf = self
                        else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let userAuthorized = userAuthorized {
                        AuthorizationManager.shared.resetAuthorization(refreshedAuthorization: userAuthorized)
                        strongSelf.requestsToRetry.forEach { $0(true, 0.0) }
                    }else{
                        AuthorizationManager.shared.resetAuthorization(refreshedAuthorization: ApiUserTokenRefreshed())
                        strongSelf.requestsToRetry.forEach { $0(false, 0.0) }
                    }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping (ApiUserTokenRefreshed?) -> ()) {
        guard !isRefreshing
            else { return }
        
        isRefreshing = true
        
        let parameters: [String: Any] = [
           "refresh_token": AuthorizationManager.shared.refreshToken
        ]
        
        sessionManager.request(refreshTokenUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseObject{ [weak self] (res: DataResponse<ApiUserTokenRefreshed>) in
            guard let strongSelf = self
                else { return }
            
            if let json = res.result.value, !json.access_token.isEmpty{
                completion(json)
            } else {
                completion(nil)
            }
            
            strongSelf.isRefreshing = false
        }
    }
}
