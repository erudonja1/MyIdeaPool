//
//  RegisterViewModel.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import Alamofire

protocol RegisterViewDelegate: class {
    func registrationSucceeded(user: ApiUserAuthorized)
    func registrationFailed(error: Error)
    func fetchedPersonalData(me: ApiUser)
}

class RegisterViewModel {
    
    weak var delegate: RegisterViewDelegate?
    
    func registerUser(email: String, name: String, password: String){
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/users", method: HTTPMethod.post, encoding: JSONEncoding(), params: ["email": email, "name": name, "password": password])
        apiService.execute(request: request).responseObject{(response: DataResponse<ApiUserAuthorized>) in
            
            if let _error = response.error{
                self.delegate?.registrationFailed(error: _error)
                return
            }
            
            //these two are exclusively
            if let _error = response.result.error{
                self.delegate?.registrationFailed(error: _error)
                return
            }
            
            if let _authorization = response.value{
                AuthorizationManager.shared.resetAuthorization(authorization: _authorization)
                self.delegate?.registrationSucceeded(user: _authorization)
            }
        }
    }

    func fetchUser(){
        let apiService = BaseApiService()
        
        let request = apiService.buildRequest(path: "/me", method: HTTPMethod.get, encoding: URLEncoding())
        apiService.execute(request: request).responseObject{(response: DataResponse<ApiUser>) in
            
            if let _error = response.error{
                AuthorizationManager.shared.resetAuthorization(authorization: ApiUserAuthorized())
                self.delegate?.registrationFailed(error: _error)
                return
            }
            
            //these two are exclusively
            if let _error = response.result.error{
                AuthorizationManager.shared.resetAuthorization(authorization: ApiUserAuthorized())
                self.delegate?.registrationFailed(error: _error)
                return
            }
            
            if let _me = response.value{
                self.delegate?.fetchedPersonalData(me: _me)
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // Definition for regex rules
        //        ^                         Start anchor
        //        (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
        //        (?=.*[!@#$&*])            Ensure string has one special case letter.
        //        (?=.*[0-9].*[0-9])        Ensure string has two digits.
        //        (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
        //        .{8,}                     Ensure string is minimum length 8.
        //        $                         End anchor.
        
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
