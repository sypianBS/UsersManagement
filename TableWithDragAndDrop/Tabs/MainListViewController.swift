//
//  MainListViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class MainListViewController: UIViewController {
    let defaults = UserDefaults.standard
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private let localJSONFileName = "Users"
    private var cancellables: Set<AnyCancellable> = []
    private let searchController = UISearchController(searchResultsController: nil)
    static var favoritesList = CurrentValueSubject<[User], Never>([])
    let newUser = PassthroughSubject<User, Never>()
    
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
        return table
    }()
    
    private var usersListURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/users"
        return components
    }
    
    var useLocalFileIfDownloadFailed: Bool {
        return defaults.bool(forKey: UserDefaultsKeys.useLocalFileIfDownloadFailed)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showMyViewControllerInACustomizedSheet))
        
        setupSearchController()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        if let url = usersListURLComponents.url {
            decodeJSON(url: url, localFileName: useLocalFileIfDownloadFailed ? localJSONFileName : nil)
                .receive(on: RunLoop.main) //for updating UI, main thread is needed
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error ", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }, receiveValue: { (users: [User]) in
                    self.users = users
                    self.filteredUsers = users
                    self.setupUsersSections()
                }).store(in: &cancellables)
        }
        
        MainListViewController.favoritesList
            .receive(on: RunLoop.main)
            .sink { favoriteUsers in
                self.tableView.reloadData()
            }.store(in: &cancellables)
        
        newUser
            .receive(on: RunLoop.main)
            .sink { user in
                self.users.append(user)
                self.filteredUsers = self.users
                self.setupUsersSections()
            }.store(in: &cancellables)
    }
        
    //alphabetical sort based on https://stackoverflow.com/questions/28087688/alphabetical-sections-in-table-table-view-in-swift it also considers the fact that the surname is the last word of the name property (e.g. Schulist in Mrs. Dennis Schulist)
    private func setupUsersSections() {
        let groupedUsersDictionary = Dictionary(grouping: self.users, by: {String($0.name.components(separatedBy: " ").last?.prefix(1) ?? "")})
           let keys = groupedUsersDictionary.keys.sorted()
        self.sections = keys.map{ Section(letter: $0, users: groupedUsersDictionary[$0]!.sorted()) }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let useLineSeparators = defaults.bool(forKey: UserDefaultsKeys.useLineSeparators)
        self.tableView.separatorStyle = useLineSeparators ? .singleLine : .none
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
        let viewControllerToPresent = AddUserViewController(newUserPublisher: newUser)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.large()] //large sheet size
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.preferredCornerRadius = 16
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
            if MainListViewController.favoritesList.value.contains(user) {
                cell.unmarkAsFavorite()
            }
            return setupCell(cell: cell, user: user)
        }
    }
    
    private func setupCell(cell: UserTableViewCell, user: User) -> UserTableViewCell {
        cell.nameLabel.text = user.name
        cell.companyLabel.text = user.company?.name
        //additional check needed due to the filtered-unfiltered results table differences
        if MainListViewController.favoritesList.value.contains(user) {
            cell.markAsFavorite()
        } else {
            cell.unmarkAsFavorite()
        }
        
        cell.favoriteButtonAction = {
            //add if not containing, remove if containing - this will toggle the behavior of tapping on the favorite
            //why not Set / NSSet ? -> because we need to keep the order since favorites can be reordered in the favorites tab
            if !MainListViewController.favoritesList.value.contains(user) {
                MainListViewController.favoritesList.value.append(user)
                cell.markAsFavorite()
            }
            else {
                if let index = MainListViewController.favoritesList.value.firstIndex(of: user)
                {
                    MainListViewController.favoritesList.value.remove(at: index)
                    cell.unmarkAsFavorite()
                }
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


