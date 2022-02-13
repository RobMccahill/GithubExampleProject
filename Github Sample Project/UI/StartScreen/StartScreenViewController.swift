//
//  StartScreenViewController.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 12/02/2022.
//

import UIKit

class StartScreenViewController: UIViewController {
    @IBOutlet var usersView: UIView!
    @IBOutlet var repositoriesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
    }
}
