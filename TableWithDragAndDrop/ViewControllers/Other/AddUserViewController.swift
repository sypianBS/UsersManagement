//
//  AddUserViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 25.03.22.
//

import UIKit
import Combine

class AddUserViewController: UIViewController {
    
    let newUser: PassthroughSubject<User, Never>
    var name: String? = nil
    var numberOfUsers: Int!
    let firstNameInputTextfield = UITextField()
    let lastNameInputTextfield = UITextField()
    let companyInputTextfield = UITextField()

    var newUserStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
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
        basicUISetup()
    }
    
    private func basicUISetup() {
        view.backgroundColor = .white
        
        view.addSubview(sheetTitleLabel)
        sheetTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sheetTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48).isActive = true
        view.addSubview(newUserStackView)
        newUserStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newUserStackView.topAnchor.constraint(equalTo: sheetTitleLabel.bottomAnchor, constant: 24).isActive = true
        
        let firstNameInput = makeLabelTextInputStackView(labelName: "First name", textFieldPlaceholder: "e.g. John", textfieldReference: firstNameInputTextfield)
        let lastName = makeLabelTextInputStackView(labelName: "Last name", textFieldPlaceholder: "e.g. Doe", textfieldReference: lastNameInputTextfield)
        let company = makeLabelTextInputStackView(labelName: "Company", textFieldPlaceholder: "e.g. Google", textfieldReference: companyInputTextfield)
        
        newUserStackView.addArrangedSubview(firstNameInput)
        newUserStackView.addArrangedSubview(lastName)
        newUserStackView.addArrangedSubview(company)
        
        let addUserButton = makeRoundedButtonWithLabel(buttonStyle: .add)
        let dismissButton = makeRoundedButtonWithLabel(buttonStyle: .discard)
        view.addSubview(addUserButton)
        view.addSubview(dismissButton)
        addUserButton.topAnchor.constraint(equalTo: newUserStackView.bottomAnchor, constant: 40).isActive = true
        addUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.topAnchor.constraint(equalTo: addUserButton.bottomAnchor, constant: 24).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addUserButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUser)))
        dismissButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSheet)))
    }
    
    init(newUserPublisher: PassthroughSubject<User, Never>, numberOfUsers: Int){
        self.newUser = newUserPublisher
        self.numberOfUsers = numberOfUsers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addUser() {
        guard let firstName = firstNameInputTextfield.text, let lastName = lastNameInputTextfield.text, let company = companyInputTextfield.text else {
            return
        }
        if firstName.isEmpty || lastName.isEmpty || company.isEmpty {
            return
        }
        
        //for simplicity, just increment the users count by 1 for the new ID
        let newUser = User(id: numberOfUsers + 1, name: firstName + " " + lastName, username: "no username", email: "", address: nil, phone: nil, website: nil, company: Company(name: company, catchPhrase: nil, bs: nil))
        self.newUser.send(newUser)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissSheet() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func makeLabelTextInputStackView(labelName: String, textFieldPlaceholder: String, textfieldReference: UITextField) -> UIStackView {
        let labelTextInputStackView = UIStackView()
        labelTextInputStackView.translatesAutoresizingMaskIntoConstraints = false
        labelTextInputStackView.axis = .horizontal
        labelTextInputStackView.spacing = 16
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelName + ":"
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.font = UIFont.systemFont(ofSize: 19)
        
        textfieldReference.translatesAutoresizingMaskIntoConstraints = false
        textfieldReference.text = nil
        textfieldReference.placeholder = textFieldPlaceholder
        textfieldReference.font = UIFont.systemFont(ofSize: 19)
        
        labelTextInputStackView.addArrangedSubview(label)
        labelTextInputStackView.addArrangedSubview(textfieldReference)
        
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
        textLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        
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
