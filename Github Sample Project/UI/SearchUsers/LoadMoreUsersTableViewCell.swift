//
//  LoadMoreUsersTableViewCell.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import UIKit

class LoadMoreUsersTableViewCell: UITableViewCell {
    @IBOutlet var loadMoreUsersLabel: UILabel!
    weak var delegate: LoadMoreUsersTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(loadMoreUsersTapped))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func loadMoreUsersTapped() {
        delegate?.loadMoreUsersTapped()
    }
    
}

protocol LoadMoreUsersTableViewCellDelegate: AnyObject {
    func loadMoreUsersTapped()
}
