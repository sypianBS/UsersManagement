//
//  MainListViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class MainListViewController: UIViewController {
    
    struct Section {
        let letter : String
        let users : [User]
    }
    
    var sections = [Section]()
    
    private var users: [User] = []
    let localJSONFileName = "Users"
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var usersListURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/users"
        return components
    }
    
    var observers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        if let url = usersListURLComponents.url {
            decodeJSON(url: url, locaFileName: localJSONFileName)
                .receive(on: RunLoop.main) //for updating UI, main thread is needed
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }, receiveValue: { (users: [User]) in
                    self.users = users
                    //alphabetical sort based on https://stackoverflow.com/questions/28087688/alphabetical-sections-in-table-table-view-in-swift it also considers the fact that the surname is the last word of the name property (e.g. Schulist in Mrs. Dennis Schulist)
                    let groupedUsersDictionary = Dictionary(grouping: users, by: {String($0.name.components(separatedBy: " ").last?.prefix(1) ?? "")})
                       let keys = groupedUsersDictionary.keys.sorted()
                    self.sections = keys.map{ Section(letter: $0, users: groupedUsersDictionary[$0]!.sorted()) }
                    self.tableView.reloadData()
                }).store(in: &observers)
        }
    }
}

extension MainListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = sections[indexPath.section]
        let user = section.users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
}

//sections
extension MainListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].users.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
}
