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
    
    var eventHandler: EventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        
        let usersTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchUsersTapped))
        usersView.addGestureRecognizer(usersTappedRecognizer)
        
        let repositoriesTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchRepositoriesTapped))
        repositoriesView.addGestureRecognizer(repositoriesTappedRecognizer)
    }
    
    @objc func searchUsersTapped() {
        eventHandler.searchUsersTapped()
    }
    
    @objc func searchRepositoriesTapped() {
        eventHandler.searchRepositoriesTapped()
    }
}

extension StartScreenViewController {
    struct EventHandler {
        let searchUsersTapped: () -> Void
        let searchRepositoriesTapped: () -> Void
    }
}
