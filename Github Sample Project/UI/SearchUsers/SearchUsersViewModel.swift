//
//  SearchUsersViewModel.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import Foundation

class SearchUsersViewModel {
    typealias UserRepository = (_ query: String, _ userCount: Int, _ completionHandler: @escaping (Result<([SearchedUser], Int), Error>) -> Void) -> Void
    
    let repository: UserRepository
    
    private var userCount: Int = 8
    private var activeQuery: String? = nil
    
    private var searchState: SearchState = .enterTextPrompt {
        didSet {
            stateListener(searchState)
        }
    }
    
    var stateListener: ((SearchState) -> Void)! {
        didSet {
            if stateListener != nil {
                stateListener(searchState)
            }
        }
    }
    
    init(repository: @escaping UserRepository) {
        self.repository = repository
    }
    
    func search(usingQuery query: String?) {
        activeQuery = query
        
        guard let query = query, !query.isEmpty else {
            self.searchState = .enterTextPrompt
            return
        }
        
        self.searchState = .loading
        
        repository(query, userCount) { result in
            switch result {
            case .success(let (users, totalCount)):
                let remainingUserCount = min(totalCount, 100) - users.count
                
                var items: [UserItem] = users.map { UserItem.user($0) }
                
                if remainingUserCount > 0 {
                    items.append(.loadMoreUsers(count: remainingUserCount))
                }
                
                self.searchState = .returnedUsers(items: items)
            case .failure(_):
                self.searchState = .noResults(message: "Something went wrong - please try again later!")
            }
        }
    }
    
    func loadMoreTapped() {
        userCount += 8
        search(usingQuery: activeQuery)
    }
    
    enum SearchState: Equatable {
        case loading
        case noResults(message: String)
        case returnedUsers(items: [UserItem])
    }
    
    enum UserItem: Equatable, Hashable {
        case loadMoreUsers(count: Int)
        case user(SearchedUser)
    }
}

extension SearchUsersViewModel.SearchState {
    fileprivate static var enterTextPrompt: Self {
        .noResults(message: "Use the Search Bar above to search for a user")
    }
    
    var isLoading: Bool {
        self == .loading
    }
    
    var noResultsFound: Bool {
        switch self {
        case .noResults(_):
            return true
        default:
            return false
        }
    }
}
