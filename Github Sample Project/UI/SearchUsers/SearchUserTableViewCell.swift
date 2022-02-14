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
    
    private var imageCache: ImageCache?
    private var user: SearchedUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        userImageView.image = UIImage(systemName: "user.circle.fill")
        guard let url = user?.imageURL else { return }
        imageCache?.removeRequest(forUrl: url)
    }
    
    func configure(with user: SearchedUser, imageCache: ImageCache) {
        userNameLabel.text = user.name
        
        imageCache.image(forUrl: user.imageURL) { [weak self] image in
            UIView.animate(withDuration: 0.25) {
                self?.userImageView.image = image ?? UIImage(systemName: "user.circle.fill")
            }
        }
    }
}
