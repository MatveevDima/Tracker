//
//  CategoryTableCell.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 27.07.2024.
//

import UIKit

final class CategoryTableCell : UITableViewCell {
    
    // MARK: - Public Properties
    static let identifier = "CategoryTableCell"
    
    // MARK: - Private Properties
    private lazy var accessoryImage: UIImageView = {
        let image = UIImage(systemName: "checkmark")?.withTintColor(.blue)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        return imageView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Actions
    func showImage() {
        accessoryImage.isHidden = false
    }
    
    func hideImage() {
        accessoryImage.isHidden = true
    }
    
    // MARK: - setupView
    private func setupView() {
        
        contentView.backgroundColor = UIColor(named: "light_gray_for_background")
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(accessoryImage)
        
        NSLayoutConstraint.activate([
            accessoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            accessoryImage.widthAnchor.constraint(equalToConstant: 30),
            accessoryImage.heightAnchor.constraint(equalToConstant: 30),
            accessoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
