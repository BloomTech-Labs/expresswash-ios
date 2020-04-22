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
    
    //MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    //MARK: - Methods
    
    func setupSubviews() {
        nameTextField.underline()
        emailAddressTextField.underline()
        passwordTextField.underline()
        addButton(to: passwordTextField)
        confirmTextField.underline()
        addButton(to: confirmTextField)
        
        backgroundView.layer.cornerRadius = 20.0
    }
    
    func addButton(to textField: UITextField) {
        
        let button = UIButton(type: .custom)
        
        if textField.isSecureTextEntry {
            button.setTitle("●",for: .normal)
            button.titleLabel!.textColor = UIColor.init(named: "Salmon")
        } else {
            button.setTitle("○",for: .normal)
            button.titleLabel!.textColor = UIColor.init(named: "Salmon")
        }
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.unhide), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    @objc func unhide() {
        
        setupSubviews()
    }
    
    //MARK: - Actions
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension UITextField {

    func underline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.init(named: "Salmon")?.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
