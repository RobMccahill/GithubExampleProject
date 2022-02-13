//
//  UserSearchService.swift
//  Github Sample Project
//
//  Created by Robert Mccahill on 13/02/2022.
//

import Foundation

struct UserSearchService {
    private let baseURL = "https://api.github.com/search/users"
    let session: URLSession = .shared
    
    func searchUsers(
        using query: String,
        userCount: Int,
        completion: @escaping (Result<SearchedUserResponse, UserSearchService.SearchError>) -> Void
    ) {
        let url = URL(string: "\(baseURL)?q=\(query)&per_page=\(userCount)")!
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let response = try? decoder.decode(UserSearchService.SearchedUserResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(response))
        }.resume()
    }
}

extension UserSearchService {
    struct SearchedUserResponse: Decodable {
        let totalCount: Int
        let items: [User]
        
        struct User: Decodable {
            let id: Int
            let login: String
            let avatarUrl: String
        }
    }
    
    enum SearchError: Error {
        case requestFailed
        case decodingError
    }
}
