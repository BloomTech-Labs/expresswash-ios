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
    private var userController = UserController()

    // MARK: - Outlets

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
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

        if confirmTextField.isSecureTextEntry {
            confirmButton.setTitle("●", for: .normal)
        } else {
            confirmButton.setTitle("○", for: .normal)
        }

        confirmButton.setTitleColor(UIColor(named: "Salmon"), for: .normal)
        confirmButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        confirmButton.frame = rect
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

    // MARK: - Actions

    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailAddressTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let confirm = confirmTextField.text, !confirm.isEmpty else { return }

        if password == confirm {
            userController.registerUser(with: firstName, lastName, email, password)
            self.performSegue(withIdentifier: "finishedSignUpSegue", sender: self)
        } else {
            let alertController = UIAlertController(title: "Passwords Don't Match", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
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
            return true
        } else {
            return false
        }
    }
}
