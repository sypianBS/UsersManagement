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
        
        navigationItem.title = "Favorite users"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        MainListViewController.favoritesSet
            .receive(on: RunLoop.main)
            .sink { value in
                self.tableView.reloadData()
            }.store(in: &cancellables)
    }

}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainListViewController.favoritesSet.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sortedNames = Array(MainListViewController.favoritesSet.value).sorted(by: {
            $0.name.components(separatedBy: " ").last! < $1.name.components(separatedBy: " ").last!
        })
        cell.textLabel?.text = sortedNames[indexPath.row].name
        return cell
    }
    
}
