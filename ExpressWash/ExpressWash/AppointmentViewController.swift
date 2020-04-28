//
//  AppointmentViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {

    //MARK: - Properties
    
    //MARK: - Outlets
    
    @IBOutlet weak var addressTextField: UITextView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var jobCompleteButton: UIButton!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Methods
    
    //MARK: - Actions
    
    @IBAction func jobCompleteTapped(_ sender: Any) {
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
