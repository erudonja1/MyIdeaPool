//
//  LoginViewController.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController, LoginViewDelegate {
    @IBOutlet weak var loginTitle: UILabel!
    
    @IBOutlet weak var emailInputField: CustomTextInputField!
    @IBOutlet weak var passwordInputField: CustomTextInputField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var donthaveaccountLabel: UILabel!
    
    private var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self as LoginViewDelegate
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setNavigation(withBackButton: false)
    }
    
    
    private func setView(){
        emailInputField.textField.placeholder = "Email"
        emailInputField.textField.keyboardType = .emailAddress
        passwordInputField.textField.placeholder = "Password"
        passwordInputField.textField.isSecureTextEntry = true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // check validation of the form
        if isValid() == false {
            return
        }
        
        guard let email = emailInputField.textField.text else { return }
        guard let password = passwordInputField.textField.text else { return }
        viewModel.loginUser(username: email, password: password)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // LoginViewDelegate methods
    func loginSucceeded() {
        viewModel.fetchUser()
    }
    
    func loginFailed(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchedPersonalData(me: ApiUser) {
        // user not used still
        let vc = ListOfIdeasViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isValid() -> Bool{
        // validate email field
        let (validEmail, msgEmail) = validateField(emailInputField.textField)
        if validEmail == false {
            let alert = UIAlertController(title: "Error", message: msgEmail, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        // validate password field
        let (validPass, msgPass) = validateField(passwordInputField.textField)
        if validPass == false {
            let alert = UIAlertController(title: "Error", message: msgPass, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    private func validateField(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        switch textField {
        case emailInputField.textField:
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return (false, "Email can't be empty")
            }
            
            return (viewModel.isValidEmail(text), "Email invalid.")
        case passwordInputField.textField:
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return (false, "Password can't be empty")
            }
            return (true, nil)
        default:
            return (true, nil)
        }
    }
    
}
