//
//  RepositoryDataView.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation

struct RepositoryDataView {
    
    let name: String
    let description: String
    let forksCount: String
    let stargazersCount: String
    let owner: UserDataView
    let htmlUrl: URL
    
    init(repository: Repository) {
        self.name = repository.name ?? "Untitled"
        self.description = repository.description ?? "No description available"
        self.forksCount = String(format: "%d forks", repository.forksCount)
        self.stargazersCount = String(format: "%d stars", repository.stargazersCount)
        self.htmlUrl = repository.htmlUrl
        self.owner = UserDataView(user: repository.owner)
    }
    
}
