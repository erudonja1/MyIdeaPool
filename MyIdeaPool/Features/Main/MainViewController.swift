//
//  ViewController.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/3/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var logoBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoBackgroundView.layer.cornerRadius = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()

        UIView.transition(with: logoBackgroundView, duration: 1, options: .curveEaseIn, animations: {
            self.logoBackgroundView.backgroundColor = UIColor.white
        }, completion: { _ in
            self.checkAuthorization()
        })
    }
    
    private func checkAuthorization(){
        if AuthorizationManager.shared.isLoggedIn() {
            navigateToHome()
        }else {
            navigateToLogin()
        }
    }

    private func navigateToLogin(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToHome(){
        let vc = ListOfIdeasViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

