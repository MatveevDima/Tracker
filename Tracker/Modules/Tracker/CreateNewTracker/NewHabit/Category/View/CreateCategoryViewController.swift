//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 27.07.2024.
//

import UIKit

final class CreateCategoryViewController : UIViewController {
    
    weak var delegate: CategoryViewControllerProtocol?
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Новая категория"
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = .black
        return headerLabel
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton(type: .custom)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.backgroundColor = .black
        addCategoryButton.setTitleColor(.white, for: .normal)
        addCategoryButton.setTitle("Готово", for: .normal)
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.layer.masksToBounds = true
        addCategoryButton.isEnabled = false
        
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        
        return addCategoryButton
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название категории"
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.textColor = .black
        textField.backgroundColor =  UIColor(named: "light_gray_for_background")
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(didChangeTitleTextField), for: .allEditingEvents)
        textField.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: setupView
    private func setupView() {
        
        view.backgroundColor = .white
        
        setupHeaderLabel()
        setupTextField()
        setupAddCategoryButton()
    }
    
    func setupHeaderLabel() {
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTextField() {
        
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
    
    // MARK: Actions
    @objc
    private func didTapAddCategoryButton() {
        
        guard let categoryName = textField.text else {return}
        let newCategory = TrackerCategory(id: UUID(), name: categoryName, trackers: [])
        trackerCategoryStore.saveCategoryToCoreData(newCategory)
        didCreatedNewCategory()
    }
    
    @objc
    private func didChangeTitleTextField() {
        
        let text = textField.text ?? ""
        
        if (text.isEmpty) {
            addCategoryButton.isEnabled = false
        } else {
            addCategoryButton.isEnabled = true
        }
    }
}

extension CreateCategoryViewController : CategoryDelegate {
    
    func didCreatedNewCategory() {
        delegate?.didCreatedNewCategory()
        dismiss(animated: true)
    }
}
