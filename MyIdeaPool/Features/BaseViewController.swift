//
//  BaseInputViewController.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/5/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setNavigation(withBackButton showBack: Bool){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.title = ""
        navigationController?.navigationItem.title = ""
        navigationController?.navigationItem.titleView = nil
        
        // addition for back button
        navigationItem.leftItemsSupplementBackButton = showBack
        
        // set the title
        let customNavigation = CustomNavigationBar()
        let titleItem = UIBarButtonItem(customView:customNavigation)
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [titleItem, flexibleSpace]
        navigationItem.rightBarButtonItems = []
    }
    
    
}
