//
//  RepositoriesPresenter.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol RepositoriesViewDelegate: class {
    func reloadData()
    func insertRepositories(in range: Range<Int>)
    func showRepositoryPage(address: URL)
    func presentError(message: String)
    func setLoading(_ isLoading: Bool)
    func shareRepository(url address: URL)
}

protocol RepositoriesPresenterDelegate: class {
    
    var numberOfRepositories: Int { get }
    
    func fetchRepositories()
    func refreshRepositories()
    func repository(at index: Int) -> RepositoryDataView
    func willDisplayRepository(at index: Int)
    func didSelectRepository(at index: Int)
    func didTapShareRepository(at index: Int)
    
}

class RepositoriesPresenter: RepositoriesPresenterDelegate {
    
    weak var delegate: RepositoriesViewDelegate?
    
    var service: RepositorySearchService?
    
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    private var repositories: [Repository] = []
    private var currentPage = 1
    private var isLoading = false {
        didSet {
            delegate?.setLoading(isLoading)
        }
    }
    
    init(service: RepositorySearchService) {
        self.service = service
    }
    
    func fetchRepositories() {
        isLoading = true
        service?.fetchPopularSwiftRepositories(atPage: currentPage, completion: { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let repositoriesResponse):
                self?.didFetchRepositories(repositoriesResponse: repositoriesResponse)
            case .failure(let error):
                self?.delegate?.presentError(message: error.localizedDescription)
            }
        })
    }
    
    func refreshRepositories() {
        self.repositories = []
        self.currentPage = 1
        delegate?.reloadData()
        fetchRepositories()
    }
    
    func repository(at index: Int) -> RepositoryDataView {
        return RepositoryDataView(repository: repositories[index])
    }
    
    func willDisplayRepository(at index: Int) {
        guard index == repositories.count - 1 && !isLoading else { return }
        fetchRepositories()
    }
    
    func didSelectRepository(at index: Int) {
        delegate?.showRepositoryPage(address: repositories[index].htmlUrl)
    }
    
    func didTapShareRepository(at index: Int) {
        delegate?.shareRepository(url: repositories[index].htmlUrl)
    }
    
    private func didFetchRepositories(repositoriesResponse: RepositoriesResponse) {
        let lowerBand = repositories.count
        let upperBand = repositories.count + repositoriesResponse.items.count
        repositories.append(contentsOf: repositoriesResponse.items)
        currentPage += 1
        delegate?.insertRepositories(in: lowerBand..<upperBand)
    }
    
}
