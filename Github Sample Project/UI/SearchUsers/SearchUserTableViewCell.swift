//
//  SearchUserTableViewCell.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with user: SearchedUser) {
        userNameLabel.text = user.name
    }
}
