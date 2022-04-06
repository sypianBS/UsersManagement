//
//  UsersViewModel.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 06.04.22.
//

import Foundation
import Combine

class UsersViewModel {
    
    var users: [User] = []
    var filteredUsers: [User] = []
    var sections = [Section]()
    
    let newUser = PassthroughSubject<User, Never>()
    static var favoritesList = CurrentValueSubject<[User], Never>([])
    
    struct Section {
        let letter : String
        let users : [User]
    }
    
    let localJSONFileName = "Users"
    
    let usersListURLComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/users"
        return components
    }()
    
}
