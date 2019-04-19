//
//  RepositoriesTests.swift
//  PopReposTests
//
//  Created by Leonardo Oliveira on 18/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import XCTest
@testable import PopRepos

class RepositoriesTests: XCTestCase {
    
    var sut: RepositoriesPresenter!
    var spy: RepositoriesViewSpy!
    
    var serviceMock: RepositorySearchServiceMock!
    
    override func setUp() {
        serviceMock = RepositorySearchServiceMock(configuration: .github)
        sut = RepositoriesPresenter(service: serviceMock)
        spy = RepositoriesViewSpy()
        sut.delegate = spy
    }

    override func tearDown() {
        sut = nil
        spy = nil
        serviceMock = nil
    }
    
    func testFetchRepositoriesSuccessfully() {
        sut.fetchRepositories()
        
        XCTAssertTrue(spy.setLoadingTrueCalled)
        XCTAssertTrue(spy.setLoadingFalseCalled)
        XCTAssertTrue(spy.insertRepositoriesInRangeCalled)
    }
    
    func testFetchRepositoriesFail() {
        serviceMock.requestsShouldFail = true
        sut.fetchRepositories()
        
        XCTAssertTrue(spy.setLoadingTrueCalled)
        XCTAssertTrue(spy.setLoadingFalseCalled)
        XCTAssertTrue(spy.presentErrorMessageCalled)
    }

    func testRefreshRepositoriesSuccessfully() {
        sut.refreshRepositories()
        
        XCTAssertTrue(spy.reloadDataCalled)
        XCTAssertTrue(spy.setLoadingTrueCalled)
        XCTAssertTrue(spy.setLoadingFalseCalled)
        XCTAssertTrue(spy.insertRepositoriesInRangeCalled)
    }
    
    func testRefreshRepositoriesFail() {
        serviceMock.requestsShouldFail = true
        sut.refreshRepositories()
        
        XCTAssertTrue(spy.reloadDataCalled)
        XCTAssertTrue(spy.setLoadingTrueCalled)
        XCTAssertTrue(spy.setLoadingFalseCalled)
        XCTAssertTrue(spy.presentErrorMessageCalled)
    }
    
    func testInfinityScroll() {
        sut.fetchRepositories()
        spy.setLoadingTrueCalled = false
        spy.setLoadingTrueCalled = false
        spy.insertRepositoriesInRangeCalled = false
        sut.willDisplayRepository(at: 29)
        
        XCTAssertTrue(spy.setLoadingTrueCalled)
        XCTAssertTrue(spy.setLoadingFalseCalled)
        XCTAssertTrue(spy.insertRepositoriesInRangeCalled)
    }
    
    func testShowRepositoryPage() {
        sut.fetchRepositories()
        sut.didSelectRepository(at: 0)
        
        XCTAssertTrue(spy.showRepositoryPageAddressCalled)
    }
    
    func testShareCalled() {
        sut.fetchRepositories()
        sut.didTapShareRepository(at: 0)
        
        XCTAssertTrue(spy.shareRepositoryUrlAddressCalled)
    }
    
}
