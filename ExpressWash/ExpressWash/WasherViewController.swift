//
//  WasherViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class WasherViewController: UIViewController {

<<<<<<< master
    // MARK: - Properties

    // MARK: - Outlets

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods

    // MARK: - Actions

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

=======
    //MARK: - Properties
    
    //MARK: - Outlets
    
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Methods
    
    //MARK: - Actions
    
    @IBAction func activeSwitchToggled(_ sender: Any) {
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
>>>>>>> Added Storyboard Layout & Wired up VC Files Accordingly
    }
}
