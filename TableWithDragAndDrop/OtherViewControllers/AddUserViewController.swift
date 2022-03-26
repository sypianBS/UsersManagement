//
//  AddUserViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 25.03.22.
//

import UIKit

class AddUserViewController: UIViewController {

    var newUserStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var sheetTitleLabel: UILabel = {
        let sheetTitleLabel = UILabel()
        sheetTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetTitleLabel.text = "New user"
        sheetTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return sheetTitleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let addFirstNameLabel = UILabel()
        addFirstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addFirstNameLabel.text = "First name"
        
        let addFirstNameTextField = UITextField()
        addFirstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addFirstNameTextField.text = nil
        addFirstNameTextField.placeholder = "e.g. John"
        
        let firstNameStackView = UIStackView()
        firstNameStackView.axis = .horizontal
        firstNameStackView.spacing = 16
        firstNameStackView.translatesAutoresizingMaskIntoConstraints = false
        firstNameStackView.addArrangedSubview(addFirstNameLabel)
        firstNameStackView.addArrangedSubview(addFirstNameTextField)

        newUserStackView.addArrangedSubview(firstNameStackView)
        view.addSubview(sheetTitleLabel)
        sheetTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sheetTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    }

}
