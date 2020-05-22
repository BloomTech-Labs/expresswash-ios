//
//  EditProfileViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/21/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    //MARK: - Properties
    
    var user: User?
    
    //MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityStateZipTextField: UITextField!
    @IBOutlet weak var addCarsButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    //MARK: - Methods
    
    private func updateViews() {
        guard let user = user else { return }

            let url = user.profilePicture
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                profileImageView.image = image
            }
            
            fullNameTextField.text = "\(user.firstName.capitalized) \(user.lastName.capitalized)"
            phoneNumberTextField.text = user.phoneNumber
            emailAddressTextField.text = user.email
            addressTextField.text = user.streetAddress
            cityStateZipTextField.text = "\(user.city ?? "city"), \(user.state ?? "state"), \(user.zip ?? "zip")"
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addCarsButtonTapped(_ sender: Any) {
    }
}
