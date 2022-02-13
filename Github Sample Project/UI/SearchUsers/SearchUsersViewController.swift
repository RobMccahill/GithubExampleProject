//
//  SearchUsersViewController.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import UIKit

class SearchUsersViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var usersTableView: UITableView!
    @IBOutlet var messageBackgroundView: UIView!
    @IBOutlet var messageLabel: UILabel!
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userCellReuseIdentifier = "searchUserCell"
    private let loadMoreCellsReuseIdentifier = "loadMoreCell"
    private lazy var dataSource = makeDataSource()
    var viewModel: SearchUsersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        
        configureActivityIndicator()
        configureTableView()
        
        searchBar.delegate = self
        viewModel.stateListener = updateState
    }
    
    private func configureActivityIndicator() {
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func configureTableView() {
        usersTableView.register(
            UINib(nibName: "SearchUserTableViewCell", bundle: nil),
            forCellReuseIdentifier: userCellReuseIdentifier
        )
        
        usersTableView.register(
            UINib(nibName: "LoadMoreUsersTableViewCell", bundle: nil),
            forCellReuseIdentifier: loadMoreCellsReuseIdentifier
        )
        
        usersTableView.dataSource = makeDataSource()
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, SearchUsersViewModel.UserItem> {
        UITableViewDiffableDataSource<Int, SearchUsersViewModel.UserItem>(
            tableView: usersTableView,
            cellProvider: { tableView, indexPath, item in
                switch item {
                case .user(let user):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: self.userCellReuseIdentifier,
                        for: indexPath
                    ) as? SearchUserTableViewCell
                    cell?.configure(with: user)
                    return cell
                case .loadMoreUsers(let count):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: self.loadMoreCellsReuseIdentifier,
                        for: indexPath
                    ) as? LoadMoreUsersTableViewCell
                    cell?.loadMoreUsersLabel.text = "Load More Users (\(count))"
                    cell?.delegate = self
                    return cell
                }
            }
        )
    }
    
    private func updateState(_ searchState: SearchUsersViewModel.SearchState) {
        UIView.animate(withDuration: 0.25) {
            self.messageBackgroundView.alpha = (searchState.noResultsFound || searchState.isLoading) ? 1 : 0
            
            if !searchState.isLoading {
                self.activityIndicator.stopAnimating()
            }
            
            self.messageLabel.alpha = searchState.noResultsFound ? 1 : 0
        }
        
        switch searchState {
        case .loading:
            activityIndicator.startAnimating()
        case let .noResults(message):
            messageLabel.text = message
        case let .returnedUsers(items):
            applyItems(items)
        }
    }
    
    private func applyItems(_ items: [SearchUsersViewModel.UserItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchUsersViewModel.UserItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot)
    }
}

extension SearchUsersViewController: LoadMoreUsersTableViewCellDelegate {
    func loadMoreUsersTapped() {
        viewModel.loadMoreTapped()
    }
}

extension SearchUsersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(usingQuery: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(usingQuery: nil)
    }
}
