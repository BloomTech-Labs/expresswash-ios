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
    }
    
    //MARK: - Methods
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Actions
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
