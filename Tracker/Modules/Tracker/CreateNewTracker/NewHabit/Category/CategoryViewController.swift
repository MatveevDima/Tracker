//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 26.07.2024.
//

import UIKit

final class CategoryViewController : UIViewController {
    
    weak var delegate: CreateNewHabitProtocol?
    
    private let categoryService = CategoryService.shared
    
    private var categories: [TrackerCategory] = []
    
    private var pickedCategory: TrackerCategory?
    private var pickedCategoryIndex: Int?
    
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
    
    private lazy var categoryTable: UITableView = {
        let categoryTable = UITableView(frame: .zero)
        categoryTable.translatesAutoresizingMaskIntoConstraints = false
        
        categoryTable.register(CategoryTableCell.self, forCellReuseIdentifier: CategoryTableCell.identifier)
        categoryTable.isScrollEnabled = false
        categoryTable.layer.masksToBounds = true
        categoryTable.layer.cornerRadius = 16
        categoryTable.allowsMultipleSelection = false
        
        categoryTable.dataSource = self
        categoryTable.delegate = self
        
        return categoryTable
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
        let viewController = CreateCategoryViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    // MARK: Methods
    private func updateCategories() {
        
        let oldCount = categories.count
        
        categories = categoryService.categories
        
        categoryTable.performBatchUpdates { [weak self] in
            
            guard let self = self else { return }
            
            let indexPaths = (oldCount..<categories.count).map { i in
                IndexPath(row: i, section: 0)
            }
            self.categoryTable.insertRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
        } completion: { _ in }
        
        checkCategoriesIfEmpty()
    }
    
    private func checkCategoriesIfEmpty() {
        
        if (categories.isEmpty) {
            hideCategoryTable()
            showPlaceholder()
        } else {
            hidePlaceholder()
            showCategoryTable()
        }
    }
    
    private func hideCategoryTable() {
        categoryTable.isHidden = true
    }
    
    private func showCategoryTable() {
        categoryTable.isHidden = false
    }
    
    private func hidePlaceholder() {
        placeholderPic.isHidden = true
        placeholderText.isHidden = true
    }
    
    private func showPlaceholder() {
        placeholderPic.isHidden = false
        placeholderText.isHidden = false
    }
    
    // MARK: setupView
    private func setupView() {
        
        view.backgroundColor = .white
        
        setupHeaderLabel()
        setupPlaceholder()
        setupCategoryTable()
        setupAddCategoryButton()
        updateCategories()
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
        
        NSLayoutConstraint.activate([
            placeholderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupCategoryTable() {
        
        view.addSubview(categoryTable)
        
        NSLayoutConstraint.activate([
            categoryTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoryTable.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            categoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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

    // MARK: UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryTableCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableCell.identifier) as? CategoryTableCell
        else { return UITableViewCell() }
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        // Обновление состояния иконки в зависимости от выбранного индекса
        if indexPath.row == pickedCategoryIndex {
            cell.showImage()
        } else {
            cell.hideImage()
        }
              
        
        return cell
    }
}

    // MARK: UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        // Проверка, был ли ранее выбранный индекс
        if let previousIndex = pickedCategoryIndex {
            let previousIndexPath = IndexPath(item: previousIndex, section: 0)
            
            // Скрытие иконки на предыдущей ячейке
            if let previousCell = tableView.cellForRow(at: previousIndexPath) as? CategoryTableCell {
                previousCell.hideImage()
            }
            
            // Если текущая ячейка была выбрана повторно, снимаем выбор
            if previousIndex == indexPath.row {
                pickedCategoryIndex = nil
                pickedCategory = nil
                tableView.reloadRows(at: [previousIndexPath], with: .automatic)
                delegate?.setPickedCategoy(nil)
                return
            }
        }
        
        // Отображение иконки на текущей выбранной ячейке
        if let currentCell = tableView.cellForRow(at: indexPath) as? CategoryTableCell {
            currentCell.showImage()
        }
        
        pickedCategory = categories[indexPath.row]
        pickedCategoryIndex = indexPath.row
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        delegate?.setPickedCategoy(pickedCategory)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CreateNewHabitDelegate
extension CategoryViewController: CreateNewHabitDelegate {
    
}

// MARK: CategoryViewControllerProtocol
extension CategoryViewController: CategoryViewControllerProtocol {
    
    func didCreatedNewCategory() {
        updateCategories()
    }
}
