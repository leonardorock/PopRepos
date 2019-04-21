//
//  RepositoriesViewSpy.swift
//  PopReposTests
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import Foundation
@testable import PopRepos

class RepositoriesViewSpy: RepositoriesViewDelegate {
    
    var reloadDataCalled = false
    var insertRepositoriesInRangeCalled = false
    var showRepositoryPageAddressCalled = false
    var presentErrorMessageCalled = false
    var setLoadingTrueCalled = false
    var setLoadingFalseCalled = false
    var shareRepositoryUrlAddressCalled = false
    var showEmptyDataViewWithMessageCalled = false
    var hideEmptyDataViewCalled = false
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func insertRepositories(in range: Range<Int>) {
        insertRepositoriesInRangeCalled = true
    }
    
    func showRepositoryPage(address: URL) {
        showRepositoryPageAddressCalled = true
    }
    
    func presentError(message: String) {
        presentErrorMessageCalled = true
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            setLoadingTrueCalled = true
        } else {
            setLoadingFalseCalled = true
        }
    }
    
    func shareRepository(url address: URL) {
        shareRepositoryUrlAddressCalled = true
    }
    
    func showEmptyDataView(with message: String?) {
        showEmptyDataViewWithMessageCalled = true
    }
    
    func hideEmptyDataView() {
        hideEmptyDataViewCalled = true
    }
    
    
}
