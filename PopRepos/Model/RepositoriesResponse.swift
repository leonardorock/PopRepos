//
//  RepositoriesResponse.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 16/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

struct RepositoriesResponse: Codable {
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
}
