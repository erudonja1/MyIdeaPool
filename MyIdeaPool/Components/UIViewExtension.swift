//
//  UIViewExtension.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/5/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import UIKit


extension UIView{
    
    func addShadow(){
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.33).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        
    }
}
