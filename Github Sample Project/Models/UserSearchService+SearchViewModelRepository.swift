//
//  UserSearchService+SearchViewModelRepository.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import Foundation

extension UserSearchService{
    func asRepository() -> SearchUsersViewModel.UserRepository {
        return { query, userCount, completionHandler in
            self.searchUsers(
                using: query,
                userCount: userCount
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        completionHandler(.success((
                            response.items.map(SearchedUser.init),
                            response.totalCount
                        )))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
}
