//
//  RepositoryTableViewCell.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

final class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var stargazersCountLabel: UILabel!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: RemoteImageView!
    
    func prepare(for repository: RepositoryDataView) {
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        forksCountLabel.text = repository.forksCount
        stargazersCountLabel.text = repository.stargazersCount
        
        authorNameLabel.text = repository.owner.login
        authorAvatarImageView.setImage(url: repository.owner.avatarUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatarImageView.cancelImageRequest()
    }
    
}
