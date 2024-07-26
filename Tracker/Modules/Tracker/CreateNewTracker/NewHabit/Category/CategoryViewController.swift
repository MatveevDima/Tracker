//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 26.07.2024.
//

import UIKit

final class CategoryViewController : UIViewController {
    
    weak var delegate: CreateNewHabitProtocol?
    
    private var categories: [TrackerCategory] = [] //todo
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Категория"
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = .black
        return headerLabel
    }()
    
    private lazy var placeholderPic = UIImageView(image: UIImage(named: "tracker_placeholder"))
    
    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события \n можно объединить по смыслу"
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton(type: .custom)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.backgroundColor = .black
        addCategoryButton.setTitleColor(.white, for: .normal)
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.layer.masksToBounds = true
        
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        
        return addCategoryButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Actions
    @objc
    private func didTapAddCategoryButton() {
        
    }
    
    // MARK: setupView
    private func setupView() {
        
        view.backgroundColor = .white
        
        setupHeaderLabel()
        setupPlaceholder()
        setupAddCategoryButton()
    }
    
    func setupHeaderLabel() {
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPlaceholder() {
        
        view.addSubview(placeholderPic)
        view.addSubview(placeholderText)
        
        placeholderPic.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        
        if (!categories.isEmpty) {
            
            placeholderPic.isHidden = true
            placeholderText.isHidden = true
        }
        
        NSLayoutConstraint.activate([
            placeholderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupAddCategoryButton() {
        
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

extension CategoryViewController: CreateNewHabitDelegate {
    
}
