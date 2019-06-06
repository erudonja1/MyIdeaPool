//
//  CustomNumberInputField.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/5/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class CustomNumberInputField: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var label: UILabel = UILabel()
    var textField: UITextField = UITextField()
    var bottomLine: UIView = UIView()
    var arrowImage: UIImageView = UIImageView()
    private var numberPicker = UIPickerView()
    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        numberPicker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        numberPicker.delegate = self
    }
    
    private func commonInit() {
        
        addSubview(label)
        label.font = UIFont.init(name: "OpenSans-Bold", size: 14.0)
        label.textColor = UIColor.init(red: 0.16, green: 0.22, blue: 0.26, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        addSubview(textField)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.init(red: 0.16, green: 0.22, blue: 0.26, alpha: 1.0)
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.inputView = numberPicker
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -3.0).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        

        addSubview(arrowImage)
        arrowImage.image = UIImage(named: "arrowDown")
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10.0).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        arrowImage.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: 15.0).isActive = true

        addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.init(red: 0.16, green: 0.22, blue: 0.26, alpha: 0.2)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        textField.becomeFirstResponder()
    }
    
    func setDisabled(){
        arrowImage.isHidden = true
        textField.isUserInteractionEnabled = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = numbers[row]
    }
    
}
