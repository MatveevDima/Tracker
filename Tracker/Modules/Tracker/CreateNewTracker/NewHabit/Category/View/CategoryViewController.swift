//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 26.07.2024.
//

import UIKit

final class CategoryViewController : UIViewController {
    
    var viewModel: CategoryViewModel?
    weak var delegate: CreateNewHabitProtocol?
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    var pickedCategory: TrackerCategory?
    
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
        
        viewModel = CategoryViewModel()
        viewModel?.delegate = delegate
        viewModel?.selectedCategory = pickedCategory
        bind()
        
        viewModel?.getCategories()
        checkCategoriesIfEmpty()
        
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onChange = { [weak self] in
            self?.categoryTable.reloadData()
            self?.checkCategoriesIfEmpty()
        }
    }
    
    private func addInteraction(toCell cell: UITableViewCell) {
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
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
        guard let viewModel = viewModel else { return }
        viewModel.getCategories()
        categoryTable.reloadData()
        checkCategoriesIfEmpty()
    }
    
    private func checkCategoriesIfEmpty() {
        
        guard let viewModel = viewModel else { return }
        if viewModel.categoriesNumber() == 0 {
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
        guard let viewModel = viewModel else  { return 0 }
        return viewModel.categoriesNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CategoryTableCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableCell.identifier) as? CategoryTableCell
        else { return UITableViewCell() }
        
        guard let viewModel = viewModel else { return cell }
        cell.viewModel = viewModel
        cell.configure(indexPath: indexPath)
        addInteraction(toCell: cell)
        
        if (indexPath.row == viewModel.categoriesNumber() - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
              
        
        return cell
    }
}

// MARK: UIContextMenuInteractionDelegate
extension CategoryViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let viewModel = viewModel else { return nil }
        let item = viewModel.categories[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
//        { _ -> UIMenu? in
//            
//            let editAction = UIAction(title: NSLocalizedString("Edit", comment: "")) { _ in
//                let viewController = CreateNewCategoryViewController()
//                viewController.titleText = NSLocalizedString("Edit category", comment: "")
//                viewController.startingString = item.name
//                viewController.categoryId = item.id
//                viewController.delegate = self
//                self.present(viewController, animated: true)
//            }
//            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), attributes: .destructive) { _ in
//                
//                let actionSheet: UIAlertController = {
//                    let alert = UIAlertController()
//                    alert.title = NSLocalizedString("Delete category confirmation", comment: "")
//                    return alert
//                }()
//                let action1 = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) {_ in
//                    viewModel.deleteCategory(item)
//                }
//                let action2 = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
//                actionSheet.addAction(action1)
//                actionSheet.addAction(action2)
//                self.present(actionSheet, animated: true)
//            }
//            return UIMenu(title: "", children: [editAction, deleteAction])
//        }
    }
}


    // MARK: UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        viewModel.didSelectCategoryAt(indexPath: indexPath)
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
