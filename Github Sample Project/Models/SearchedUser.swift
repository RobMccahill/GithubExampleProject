//
//  SearchedUser.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import Foundation

struct SearchedUser: Hashable {
    let id: Int
    let name: String
    let imageURL: String
}

extension SearchedUser {
    init(from user: UserSearchService.SearchedUserResponse.User) {
        self.id = user.id
        self.name = user.login
        self.imageURL = user.avatarUrl
    }
}
