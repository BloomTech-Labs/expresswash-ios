//
//  SignUpViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties

    private var passwordButton = UIButton(type: .custom)
    private var confirmButton = UIButton(type: .custom)
    private var currentTappedTextField: UITextField?

    // MARK: - Outlets

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupTextFields()

        view.layoutIfNeeded()
    }

    // MARK: - Methods

    func setupSubviews() {

        let width = passwordTextField.frame.size.width
        let rect = CGRect(x: CGFloat(width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))

        if passwordTextField.isSecureTextEntry {
            passwordButton.setTitle("●", for: .normal)
        } else {
            passwordButton.setTitle("○", for: .normal)
        }

        passwordButton.setTitleColor(UIColor(named: "Salmon"), for: .normal)
        passwordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordButton.frame = rect
        passwordButton.addTarget(self, action: #selector(self.unhidePassword), for: .touchUpInside)
        passwordTextField.rightView = passwordButton
        passwordTextField.rightViewMode = .always
    }

    func setupTextFields() {
        firstNameTextField.delegate = self
//        firstNameTextField.layer.borderColor = UIColor(named: "Light Blue")?.cgColor
//        firstNameTextField.layer.borderWidth = 2.0
//        firstNameTextField.layer.cornerRadius = 5.0
        
        lastNameTextField.delegate = self
//        lastNameTextField.layer.borderColor = UIColor(named: "Light Blue")?.cgColor
//        lastNameTextField.layer.borderWidth = 2.0
//        lastNameTextField.layer.cornerRadius = 5.0
        
        emailAddressTextField.delegate = self
//        emailAddressTextField.layer.borderColor = UIColor(named: "Light Blue")?.cgColor
//        emailAddressTextField.layer.borderWidth = 2.0
//        emailAddressTextField.layer.cornerRadius = 5.0
        
        passwordTextField.delegate = self
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

    // MARK: - Actions

    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailAddressTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        UserController.shared.registerUser(account: "client", with: email, firstName, lastName, password) { (user, error) in
            if let error = error {
                print("Error registering user: \(error)")
                return
            }
            guard let user = user else { return }
            UserController.shared.sessionUser = user
        }
        self.performSegue(withIdentifier: "finishedSignUpSegue", sender: self)
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            return true
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            emailAddressTextField.becomeFirstResponder()
            return true
        } else if textField == emailAddressTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            if let count = textField.text?.count {
                if count >= 8 {
                    minimumLabel.textColor = UIColor.systemGreen
                    registerButton.isEnabled = true
                } else {
                    minimumLabel.textColor = UIColor.init(named: "Salmon")
                    registerButton.isEnabled = false
                }
            }
        }
        return true
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            return true
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            emailAddressTextField.becomeFirstResponder()
            return true
        } else if textField == emailAddressTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            confirmTextField.becomeFirstResponder()
            return true
        } else if textField == confirmTextField {
            textField.resignFirstResponder()
            guard let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty, let email = emailAddressTextField.text, !email.isEmpty,  let password = passwordTextField.text, !password.isEmpty, let confirm = confirmTextField.text, !confirm.isEmpty else { return false}
            
            if password == confirm {
                //Sign Up User!
                self.performSegue(withIdentifier: "finishedSignUpSegue", sender: self)
            } else {
                let alertController = UIAlertController(title: "Passwords Do Not Match", message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            return true
        } else {
            return false
        }
    }
}
