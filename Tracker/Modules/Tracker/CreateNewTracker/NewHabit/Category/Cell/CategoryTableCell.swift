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
    var viewModel: CategoryViewModel?
    
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
    
    func configure(indexPath: IndexPath) {
        selectionStyle = .none
        
        guard
            let viewModel = viewModel
        else { return }
        
        let category = viewModel.categories[indexPath.row]
        
        textLabel?.text = category.name
        
        guard let selectedCategory = viewModel.selectedCategory else {
            hideImage()
            return
        }
        
        if (selectedCategory == category) {
            showImage()
        } else {
            hideImage()
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    private func roundCorners() {
        let cornerRadius: CGFloat = 16
        var maskedCorners: CACornerMask = []
        
        if isFirstRow && isLastRow {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirstRow {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastRow {
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.maskedCorners = maskedCorners
    }
    
    private var isFirstRow: Bool {
        return indexPath?.row == 0
    }
    
    private var isLastRow: Bool {
        guard let tableView = superview as? UITableView else { return false }
        return indexPath?.row == tableView.numberOfRows(inSection: indexPath?.section ?? 0) - 1
    }
    
    private var indexPath: IndexPath? {
        guard let tableView = superview as? UITableView else { return nil }
        return tableView.indexPath(for: self)
    }
}
