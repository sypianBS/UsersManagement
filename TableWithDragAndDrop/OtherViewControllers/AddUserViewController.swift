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
        
        view.addSubview(sheetTitleLabel)
        sheetTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sheetTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        view.addSubview(newUserStackView)
        newUserStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newUserStackView.topAnchor.constraint(equalTo: sheetTitleLabel.bottomAnchor, constant: 24).isActive = true
        
        let firstNameInput = makeLabelTextInputStackView(labelName: "First name", textFieldPlaceholder: "e.g. John")
        let lastName = makeLabelTextInputStackView(labelName: "Last name", textFieldPlaceholder: "e.g. Doe")
        let email = makeLabelTextInputStackView(labelName: "Email", textFieldPlaceholder: "e.g. john.doe@test.com")
        
        newUserStackView.addArrangedSubview(firstNameInput)
        newUserStackView.addArrangedSubview(lastName)
        newUserStackView.addArrangedSubview(email)
        
        let addUserButton = makeRoundedButtonWithLabel(buttonStyle: .add)
        let dismissButton = makeRoundedButtonWithLabel(buttonStyle: .discard)
        view.addSubview(addUserButton)
        view.addSubview(dismissButton)
        addUserButton.topAnchor.constraint(equalTo: newUserStackView.bottomAnchor, constant: 40).isActive = true
        addUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.topAnchor.constraint(equalTo: addUserButton.bottomAnchor, constant: 24).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func makeLabelTextInputStackView(labelName: String, textFieldPlaceholder: String) -> UIStackView {
        let labelTextInputStackView = UIStackView()
        labelTextInputStackView.translatesAutoresizingMaskIntoConstraints = false
        labelTextInputStackView.axis = .horizontal
        labelTextInputStackView.spacing = 16
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelName + ":"
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = nil
        textField.placeholder = textFieldPlaceholder
        
        labelTextInputStackView.addArrangedSubview(label)
        labelTextInputStackView.addArrangedSubview(textField)
        
        return labelTextInputStackView
    }
    
    private func makeRoundedButtonWithLabel(buttonStyle: RoundedButtonStyle) -> UIView {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backgroundView.backgroundColor = buttonStyle == .add ? UIColor(red: 0, green: 202/255, blue: 0, alpha: 1.0) : .red
        backgroundView.layer.cornerRadius = 8
        
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = buttonStyle == .add ? "Add new user" : "Discard changes"
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        backgroundView.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        
        return backgroundView
    }

    enum RoundedButtonStyle {
        case discard
        case add
    }
    
}
