//
//  LoginViewModel.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import Alamofire

protocol LoginViewDelegate: class {
    func loginSucceeded()
    func loginFailed(error: Error)
    func fetchedPersonalData(me: ApiUser)
}

class LoginViewModel {
    
    weak var delegate: LoginViewDelegate?
    
    func loginUser(username: String, password: String){
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/access-tokens", method: HTTPMethod.post, encoding: JSONEncoding(), params: ["email": username, "password": password])
        apiService.execute(request: request).responseObject{(response: DataResponse<ApiUserAuthorized>) in
            
            if let _error = response.error{
                self.delegate?.loginFailed(error: _error)
                return
            }
            
            //these two are exclusively
            if let _error = response.result.error{
                self.delegate?.loginFailed(error: _error)
                return
            }
            
            if let _authorization = response.value{
                AuthorizationManager.shared.resetAuthorization(authorization: _authorization)
                self.delegate?.loginSucceeded()
            }
        }
    }
    
    func fetchUser(){
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/me", method: HTTPMethod.get, encoding: URLEncoding())
        apiService.execute(request: request).responseObject{(response: DataResponse<ApiUser>) in
            
            if let _error = response.error{
                AuthorizationManager.shared.resetAuthorization(authorization: ApiUserAuthorized())
                self.delegate?.loginFailed(error: _error)
                return
            }
            
            //these two are exclusively
            if let _error = response.result.error{
                AuthorizationManager.shared.resetAuthorization(authorization: ApiUserAuthorized())
                self.delegate?.loginFailed(error: _error)
                return
            }
            
            if let _me = response.value{
                self.delegate?.fetchedPersonalData(me: _me)
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let truncatedPass = password.trimmingCharacters(in: .whitespaces)
        return (truncatedPass.isEmpty) ? false : true
    }
}
