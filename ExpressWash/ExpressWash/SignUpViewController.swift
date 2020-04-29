//
//  SignUpViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: - Properties
    
    private var passwordButton = UIButton(type: .custom)
    private var confirmButton = UIButton(type: .custom)
    
    //MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupTextFields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    //MARK: - Methods
    
    func setupSubviews() {
        
        if passwordTextField.isSecureTextEntry {
            passwordButton.setTitle("●",for: .normal)
        } else {
            passwordButton.setTitle("○",for: .normal)
        }
        
        passwordButton.setTitleColor(UIColor(named: "Salmon"), for: .normal)
        passwordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordButton.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        passwordButton.addTarget(self, action: #selector(self.unhidePassword), for: .touchUpInside)
        passwordTextField.rightView = passwordButton
        passwordTextField.rightViewMode = .always
        
        if confirmTextField.isSecureTextEntry {
            confirmButton.setTitle("●",for: .normal)
        } else {
            confirmButton.setTitle("○",for: .normal)
        }
        
        confirmButton.setTitleColor(UIColor(named: "Salmon"), for: .normal)
        confirmButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        confirmButton.frame = CGRect(x: CGFloat(confirmTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        confirmButton.addTarget(self, action: #selector(self.unhideConfirm), for: .touchUpInside)
        confirmTextField.rightView = confirmButton
        confirmTextField.rightViewMode = .always
    }
    
    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }
    
    @objc func unhidePassword() {
        
        if passwordButton.titleLabel?.text == "●" {
            passwordTextField.isSecureTextEntry = false
            passwordButton.titleLabel?.text = "○"
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordButton.titleLabel?.text = "●"
        }
        setupSubviews()
    }
    
    @objc func unhideConfirm() {
        
        if confirmButton.titleLabel?.text == "●" {
            confirmTextField.isSecureTextEntry = false
            confirmButton.titleLabel?.text = "○"
        } else {
            confirmTextField.isSecureTextEntry = true
            confirmButton.titleLabel?.text = "●"
        }
        setupSubviews()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    //MARK: - Actions
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let name = lastNameTextField.text, !name.isEmpty, let email = emailAddressTextField.text, !email.isEmpty,  let password = passwordTextField.text, !password.isEmpty, let confirm = confirmTextField.text, !confirm.isEmpty else { return }
        
        if password == confirm {
            //Sign Up User!
            self.performSegue(withIdentifier: "finishedSignUpSegue", sender: self)
        } else {
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
