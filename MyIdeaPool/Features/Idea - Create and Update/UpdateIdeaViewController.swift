//
//  UpdateIdeaViewController.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class UpdateIdeaViewController: BaseViewController, UpdateIdeaViewDelegate {

    private var viewModel: UpdateIdeaViewModel = UpdateIdeaViewModel()
    
    @IBOutlet weak var contentInputField: CustomTextInputField!
    @IBOutlet weak var impactInputField: CustomNumberInputField!
    @IBOutlet weak var easeInputField: CustomNumberInputField!
    @IBOutlet weak var confidenceInputField: CustomNumberInputField!
    @IBOutlet weak var avgInputField: CustomNumberInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self as UpdateIdeaViewDelegate
        setViewData()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setNavigation(withBackButton: true)
    }
    
    func setModelData(idea: ApiIdea){
        viewModel.idea = idea
    }

    private func setViewData(){
        if let idea = viewModel.idea {
            contentInputField.textField.text = idea.content
            impactInputField.textField.text = String(idea.impact)
            easeInputField.textField.text = String(idea.ease)
            confidenceInputField.textField.text = String(idea.confidence)
            let roundedValueAvg = round(100 * idea.averageScore)/100
            avgInputField.textField.text = String(roundedValueAvg)
        }
    }
    
    private func setView(){
        contentInputField.textField.placeholder = "Content"
        contentInputField.textField.keyboardType = .alphabet
        contentInputField.textField.delegate = self
        
        impactInputField.label.text = "Impact"
        impactInputField.textField.delegate = self
        
        easeInputField.label.text = "Ease"
        easeInputField.textField.delegate = self
        
        confidenceInputField.label.text = "Confidence"
        confidenceInputField.textField.delegate = self
        
        avgInputField.label.text = "Avg."
        avgInputField.setDisabled()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        // check validation of the form
        if isValid() == false {
            return
        }
        
        guard let content = contentInputField.textField.text else { return }
        guard let impactText = impactInputField.textField.text, let impact = Int(impactText) else { return }
        guard let easeText = easeInputField.textField.text, let ease = Int(easeText) else { return }
        guard let confidenceText = confidenceInputField.textField.text, let confidence = Int(confidenceText) else { return }

        viewModel.save(content: content, impact: impact, ease: ease, confidence: confidence)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func saveSucceeded() {
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.removeLast()
            
            // recreate list of ides controller
            let newVc = ListOfIdeasViewController()
            viewControllers.append(newVc)
            
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func saveFailed(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UpdateIdeaViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let average = calculateAverage()
        avgInputField.textField.text = String(average)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contentInputField.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 255
        }
        return true
    }
    
    private func calculateAverage() -> Double{
        var impact = 0.0
        if let impactInput = impactInputField.textField.text, let value = Double(impactInput){
            impact = value
        }
        
        var ease = 0.0
        if let easeInput = easeInputField.textField.text, let value = Double(easeInput){
            ease = value
        }
        
        var confidence = 0.0
        if let confidenceInput = confidenceInputField.textField.text, let value = Double(confidenceInput){
            confidence = value
        }
        
        let value = (impact + ease + confidence) / 3
        let roundedValue = round(100 * value)/100
        
        return roundedValue
    }
    
    func isValid() -> Bool{
        
        // validate content field
        let (validContent, msgContent) = validateField(contentInputField.textField)
        if validContent == false {
            let alert = UIAlertController(title: "Error", message: msgContent, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        let fields: [CustomNumberInputField] = [impactInputField, easeInputField, confidenceInputField]
        for field in fields {
            let (valid, msg) = validateField(field.textField)
            if valid == false {
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    private func validateField(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        switch textField {
        case contentInputField.textField:
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return (false, "Content can't be empty")
            }
            
            return (text.count < 255, "Content too big.")
        case impactInputField.textField:
            if let doubleValue = Double(text), doubleValue > 0, doubleValue < 11 {
                return (true, nil)
            }
            return (false, "Impact value is required.")
        case easeInputField.textField:
            if let doubleValue = Double(text), doubleValue > 0, doubleValue < 11 {
                return (true, nil)
            }
            return (false, "Ease value is required.")
        case confidenceInputField.textField:
            if let doubleValue = Double(text), doubleValue > 0, doubleValue < 11 {
                return (true, nil)
            }
            return (false, "Confidence value is required.")
        default:
            return (true, nil)
        }
    }
    
}
