//
//  RegisterViewController.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: BaseViewController, RegisterViewDelegate {
    @IBOutlet weak var signUpTitle: UILabel!
    
    @IBOutlet weak var nameInputField: CustomTextInputField!
    @IBOutlet weak var emailInputField: CustomTextInputField!
    @IBOutlet weak var passwordInputField: CustomTextInputField!
    
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel!
    
    private var viewModel: RegisterViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self as RegisterViewDelegate
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setNavigation(withBackButton: false)
    }
    
    private func setView(){
        nameInputField.textField.placeholder = "Name"
        nameInputField.textField.keyboardType = .alphabet
        emailInputField.textField.placeholder = "Email"
        emailInputField.textField.keyboardType = .emailAddress
        passwordInputField.textField.placeholder = "Password"
        passwordInputField.textField.isSecureTextEntry = true
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // check validation of the form
        if isValid() == false {
            return
        }
        
        guard let email = emailInputField.textField.text else { return }
        guard let name = nameInputField.textField.text else { return }
        guard let password = passwordInputField.textField.text else { return }
        viewModel.registerUser(email: email, name: name, password: password)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // RegisterViewDelegate methods
    func registrationSucceeded(user: ApiUserAuthorized) {
        viewModel.fetchUser()
    }
    
    func registrationFailed(error: Error) {
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
        
        // validate name field
        let (validName, msgName) = validateField(nameInputField.textField)
        if validName == false {
            let alert = UIAlertController(title: "Error", message: msgName, preferredStyle: UIAlertController.Style.alert)
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
        case nameInputField.textField:
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return (false, "Name can't be empty")
            }
            return (true, nil)
        case passwordInputField.textField:
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return (false, "Password can't be empty")
            }
            
            return (viewModel.isValidPassword(text), "Your password must contain at least 8 characters, including 1 uppercase letter, 1 lowercase letter, and 1 number.")
        default:
            return (true, nil)
        }
    }
}
