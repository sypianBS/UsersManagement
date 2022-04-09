//
//  UserTableViewCell.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 20.03.22.
//

import UIKit
import Combine

class UserTableViewCell: UITableViewCell {
    
    let nameButtonStackView = UIStackView()
    let nameButtonEmailStackView = UIStackView()
    let nameLabel = UILabel()
    let companyLabel = UILabel()
    let favoriteButton = UIButton()
    var favoriteButtonAction: (() -> ())?
    private var cancellables: Set<AnyCancellable> = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameButtonStackView.axis = .horizontal
        nameButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        nameButtonEmailStackView.translatesAutoresizingMaskIntoConstraints = false
        nameButtonEmailStackView.axis = .vertical

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.textColor = .gray
               
        favoriteButton.tapPublisher
            .sink { [unowned self] in
                self.favoriteButtonAction?()
            }.store(in: &cancellables)

        let image = UIImage(systemName: "star")
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setBackgroundImage(image, for: .normal)
       
        nameButtonStackView.addArrangedSubview(nameLabel)
        nameButtonStackView.addArrangedSubview(favoriteButton)
        
        contentView.addSubview(nameButtonEmailStackView)
        nameButtonEmailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        nameButtonEmailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        nameButtonEmailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        nameButtonEmailStackView.addArrangedSubview(nameButtonStackView)
        nameButtonEmailStackView.addArrangedSubview(companyLabel)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func markAsFavorite() {
        favoriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    func unmarkAsFavorite() {
        favoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }
       
}
