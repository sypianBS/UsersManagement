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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.addSubview(newUserStackView)
        newUserStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newUserStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    }

}
