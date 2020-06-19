//
//  ProfileViewController+Toggle.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 6/19/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController {

    @objc func editEnabled() {
        editButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        editButton.isSelected = true

        if !profileTapGesture.isEnabled {
            if profileImageView.image == UIImage(systemName: "person.circle") {
                profileImageView.image = UIImage(systemName: "plus.circle")
            }
        }

        if firstNameTextField.text == "First" {
            firstNameTextField.text = nil
        }
        if lastNameTextField.text == "Last" {
            lastNameTextField.text = nil
        }
        if phoneNumberTextField.text == "Phone Number" {
            phoneNumberTextField.text = nil
        }
        if emailAddressTextField.text == "Email Address" {
            emailAddressTextField.text = nil
        }
        if addressTextField.text == "Address" {
            addressTextField.text = nil
        }
        if cityTextField.text == "City" {
            cityTextField.text = nil
        }
        if stateTextField.text == "State" {
            stateTextField.text = nil
        }
        bannerImageButton.alpha = 1
        bannerImageButton.isEnabled = true
        profileTapGesture.isEnabled = true
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        emailAddressTextField.isEnabled = true
        addressTextField.isEnabled = true
        cityTextField.isEnabled = true
        stateTextField.isEnabled = true
        carsCollectionView.alpha = 0
        addCarsButton.alpha = 1
        addCarsButton.isEnabled = true
    }

    func editDisabled() {
       editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.isSelected = false

        if profileTapGesture.isEnabled {
            if profileImageView.image == UIImage(systemName: "plus.circle") {
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
        if firstNameTextField.text == "" {
            firstNameTextField.text = "First"
        }
        if lastNameTextField.text == "" {
            lastNameTextField.text = "Last"
        }
        if phoneNumberTextField.text == "" {
            phoneNumberTextField.text = "Phone Number"
        }
        if emailAddressTextField.text == "" {
            emailAddressTextField.text = "Email Address"
        }
        if addressTextField.text == "" {
            addressTextField.text = "Address"
        }
        if cityTextField.text == "" {
            cityTextField.text = "City"
        }
        if stateTextField.text == "" {
            stateTextField.text = "State"
        }
        bannerImageButton.alpha = 0
        bannerImageButton.isEnabled = false
        profileTapGesture.isEnabled = false
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        emailAddressTextField.isEnabled = false
        addressTextField.isEnabled = false
        cityTextField.isEnabled = false
        stateTextField.isEnabled = false
        addCarsButton.alpha = 0
        addCarsButton.isEnabled = false
        carsCollectionView.alpha = 1
    }
}
