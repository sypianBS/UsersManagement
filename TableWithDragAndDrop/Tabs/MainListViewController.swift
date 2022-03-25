//
//  MainListViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class MainListViewController: UIViewController {
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private let localJSONFileName = "Users"
    private var cancellables: Set<AnyCancellable> = []
    private let searchController = UISearchController(searchResultsController: nil)
    static var favoritesSet = CurrentValueSubject<Set<User>, Never>([])
    
    var sections = [Section]()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //is user filtering the results or not
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        return table
    }()
    
    private var usersListURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/users"
        return components
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New user", style: .plain, target: self, action: #selector(showMyViewControllerInACustomizedSheet))
        
        setupSearchController()
        
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
                    self.filteredUsers = users
                    //alphabetical sort based on https://stackoverflow.com/questions/28087688/alphabetical-sections-in-table-table-view-in-swift it also considers the fact that the surname is the last word of the name property (e.g. Schulist in Mrs. Dennis Schulist)
                    let groupedUsersDictionary = Dictionary(grouping: users, by: {String($0.name.components(separatedBy: " ").last?.prefix(1) ?? "")})
                       let keys = groupedUsersDictionary.keys.sorted()
                    self.sections = keys.map{ Section(letter: $0, users: groupedUsersDictionary[$0]!.sorted()) }
                    self.tableView.reloadData()
                }).store(in: &cancellables)
        }
        
        SettingsViewController.useLineSeparators.sink { useLineSeparators in
            self.tableView.separatorStyle = useLineSeparators ? .singleLine : .none
        }.store(in: &cancellables)
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        setupSearchBarChangePublisher()
    }
    
    private func setupSearchBarChangePublisher() {

        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher
            .map {
                ($0.object as! UISearchTextField).text
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) //publish after 0.3s from the last incoming letter. Not necessarily needed in this case since there are no following http requests etc., but just keep for the sake of interest
            .sink { (searchText) in
                guard let searchText = searchText else {
                    return
                }
                self.filteredUsers = self.users.filter({ user in
                    return user.name.lowercased().contains(searchText.lowercased())
                })
                self.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    @objc private func showMyViewControllerInACustomizedSheet() {
        let viewControllerToPresent = AddUserViewController()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    struct Section {
        let letter : String
        let users : [User]
    }
}

extension MainListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }

        if !isFiltering {
            let section = sections[indexPath.section]
            let user = section.users[indexPath.row]
            return setupCell(cell: cell, user: user)
        } else {
            let user = filteredUsers[indexPath.row]
            return setupCell(cell: cell, user: user)
        }
    }
    
    private func setupCell(cell: UserTableViewCell, user: User) -> UserTableViewCell {
        cell.nameLabel.text = user.name
        cell.companyLabel.text = user.company?.name
        //additional check needed due to the filtered-unfiltered results table differences
        if MainListViewController.favoritesSet.value.contains(user) {
            cell.markAsFavorite()
        } else {
            cell.unmarkAsFavorite()
        }
        
        cell.favoriteButtonAction = {
            //add if not containing, remove if containing - this will toggle the behavior of tapping on the favorite

            if MainListViewController.favoritesSet.value.insert(user).inserted {
                cell.markAsFavorite()
            } else {
                MainListViewController.favoritesSet.value.remove(user)
                cell.unmarkAsFavorite()
            }
        }
        return cell

    }
}

//sections
extension MainListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredUsers.count
        }
        
        return sections[section].users.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return sections.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return nil
        }
        return sections[section].letter
    }
}


