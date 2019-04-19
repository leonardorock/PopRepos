//
//  RepositorySearchServiceMock.swift
//  PopReposTests
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation
@testable import PopRepos

enum FakeError: Error {
    case error
}

class RepositorySearchServiceMock: RepositorySearchService {
    
    var requestsShouldFail = false
    
    override func fetchPopularSwiftRepositories(atPage page: Int, completion: @escaping (Result<RepositoriesResponse, Error>) -> Void) {
        if !requestsShouldFail {
            let bundle = Bundle(for: RepositorySearchServiceMock.self)
            let url = URL(fileURLWithPath: bundle.path(forResource: "repositoriesResponse", ofType: "json")!)
            let data = try! Data(contentsOf: url)
            let response = try! configuration.decoder.decode(RepositoriesResponse.self, from: data)
            completion(.success(response))
        } else {
            completion(.failure(FakeError.error))
        }
    }
    
}
