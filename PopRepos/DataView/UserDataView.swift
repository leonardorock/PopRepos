//
//  UserDataView.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation

struct UserDataView {
    
    var login: String
    var avatarUrl: URL?
    
    init(user: User) {
        self.login = user.login
        self.avatarUrl = user.avatarUrl
    }
    
}
