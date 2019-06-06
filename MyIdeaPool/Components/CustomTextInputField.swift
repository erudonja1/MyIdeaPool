//
//  TextInputField.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/5/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class CustomTextInputField: UIView {

    var textField: UITextField = UITextField()
    var bottomLine: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {

        addSubview(textField)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.init(red: 0.16, green: 0.22, blue: 0.26, alpha: 1.0)
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -4.0).isActive = true
        
        addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.init(red: 0.16, green: 0.22, blue: 0.26, alpha: 0.2)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
    }
}
