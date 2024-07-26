//
//  SettingsTableCell.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 25.07.2024.
//

import UIKit

final class SettingsTableCell : UITableViewCell {
    
    // MARK: - Public Properties
    static let identifier = "SettingTableViewCell"
    
    // MARK: - Private Properties
    private lazy var accessoryImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Chevron"))
        
        return image
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = UIColor(named: "Gray")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupView
    private func setupView() {
        
        contentView.backgroundColor = UIColor(named: "light_gray_for_background")
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(accessoryImage)
        
        accessoryImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            accessoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
    }
}
