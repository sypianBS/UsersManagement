//
//  FavoritesViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAdTableView()
        setupSubscriptions()
    }
    
    private func setupNavigationBarAdTableView() {
        navigationItem.title = ProjectStrings.favoriteUsersNavigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let toggleEditingButton = UIBarButtonItem()
        toggleEditingButton.title = ProjectStrings.favoriteUsersEditButtonTitle
        toggleEditingButton.tapPublisher.sink { _ in
            self.toggleEditing()
        }.store(in: &cancellables)
        navigationItem.leftBarButtonItem = toggleEditingButton
        
        let sortAlphabeticallyButton = UIBarButtonItem()
        sortAlphabeticallyButton.image = UIImage(systemName: "arrow.up.arrow.down")
        sortAlphabeticallyButton.tapPublisher.sink { _ in
            self.sortAlphabetically()
        }.store(in: &cancellables)
        navigationItem.rightBarButtonItem = sortAlphabeticallyButton
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    private func setupSubscriptions() {
        UsersViewModel.favoritesList
            .receive(on: RunLoop.main)
            .sink { value in
                self.navigationItem.title = ProjectStrings.favoriteUsersNavigationTitleWithCounter.replacingOccurrences(of: "%%", with: "\(value.count)")
                self.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    func toggleEditing() {
        if Array(UsersViewModel.favoritesList.value).count > 0 {
            tableView.isEditing.toggle()
        }
    }
    
    func sortAlphabetically() {
        UsersViewModel.favoritesList.value = Array(UsersViewModel.favoritesList.value).sorted(by: {
            $0.name.components(separatedBy: " ").last! < $1.name.components(separatedBy: " ").last!
        })
    }

}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UsersViewModel.favoritesList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = UsersViewModel.favoritesList.value[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //deleting favorites
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            UsersViewModel.favoritesList.value.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
      
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        UsersViewModel.favoritesList.value.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}
