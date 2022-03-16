//
//  User.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 13.03.22.
//

import Foundation

struct User: Codable, Comparable {
    let id: Int
    let name, username, email: String
    let address: Address?
    let phone, website: String?
    let company: Company?
    
    //needed for sorting
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

}

struct Address: Codable {
    let street, suite, city, zipcode: String?
    let location: Location?
}

struct Location: Codable {
    let lat, lng: String?
}

struct Company: Codable {
    let name, catchPhrase, bs: String?
}
