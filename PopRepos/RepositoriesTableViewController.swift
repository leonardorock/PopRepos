//
//  RepositoriesTableViewController.swift
//  PopRepos
//
//  Created by Leonardo Oliveira on 16/04/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit
import SafariServices

final class RepositoriesTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UISearchControllerDelegate, UISearchBarDelegate, RepositoriesViewDelegate {
    
    lazy var presenter: RepositoriesPresenterDelegate = {
        let presenter = RepositoriesPresenter(service: RepositorySearchService(configuration: .github))
        presenter.delegate = self
        return presenter
    }()
    
    lazy var searchResultsController = RepositoriesTableViewController(style: .plain)
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.delegate = searchResultsController
        searchController.delegate = self
        return searchController
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.sizeToFit()
        return activityIndicatorView
    }()
    
    lazy var repositoriesRefreshControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var emptyDataView: EmptyDataView = {
        let emptyDataView = EmptyDataView(title: ":(", subtitle: nil, actionButtonTitle: nil)
        emptyDataView.hidesActionButton = true
        return emptyDataView
    }()
    
    var previewingContext: UIViewControllerPreviewing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerForPreviewingIfAvailable()
        setupNavigationController()
        presenter.fetchRepositories()
    }
    
    private func setupTableView() {
        let repositoryCellNib = UINib(nibName: String(describing: RepositoryTableViewCell.self), bundle: .main)
        tableView.register(repositoryCellNib, forCellReuseIdentifier: "repositoryCell")
        tableView.tableFooterView = activityIndicatorView
        tableView.refreshControl = repositoriesRefreshControl
    }
    
    private func setupNavigationController() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func registerForPreviewingIfAvailable() {
        if traitCollection.forceTouchCapability == .available {
            previewingContext = registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    // MARK: - Actions
    
    @objc func refreshControlValueChanged() {
        presenter.refreshRepositories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryTableViewCell
        cell.prepare(for: presenter.repository(at: indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareSwipeAction = UIContextualAction(style: .normal, title: "Share") { [unowned self] (action, view, completion) in
            self.presenter.didTapShareRepository(at: indexPath.row)
            completion(true)
        }
        shareSwipeAction.backgroundColor = tableView.tintColor
        return UISwipeActionsConfiguration(actions: [shareSwipeAction])
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRepository(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayRepository(at: indexPath.row)
    }
    
    // MARK: - View controller previewing delegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        let repository = presenter.repository(at: indexPath.row)
        let safariViewController = SFSafariViewController(url: repository.htmlUrl)
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        return safariViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.setRepositories(searchQuery: searchBar.text)
    }
    
    // MARK: - Search controller delegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        guard let previewingContext = self.previewingContext else { return }
        unregisterForPreviewing(withContext: previewingContext)
        self.previewingContext = searchController.registerForPreviewing(with: searchResultsController, sourceView: searchResultsController.tableView)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        guard let previewingContext = self.previewingContext else { return }
        unregisterForPreviewing(withContext: previewingContext)
        registerForPreviewingIfAvailable()
    }
    
    // MARK: - Repositories view delegate
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func insertRepositories(in range: Range<Int>) {
        let indexPaths = range.map { index in IndexPath(row: index, section: 0) }
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func showRepositoryPage(address: URL) {
        let safariViewController = SFSafariViewController(url: address)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func presentError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func shareRepository(url address: URL) {
        let activityViewController = UIActivityViewController(activityItems: [address], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    func showEmptyDataView(with message: String?) {
        emptyDataView.subtitleLabel.text = message
        tableView.backgroundView = emptyDataView
    }
    
    func hideEmptyDataView() {
        tableView.backgroundView = nil
    }

}
