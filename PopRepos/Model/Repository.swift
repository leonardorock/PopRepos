//
//  Repository.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 16/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation

struct Repository: Codable {
    
    let name: String?
    let description: String?
    let forksCount: Int
    let stargazersCount: Int
    let htmlUrl: URL
    let owner: User
    
}
