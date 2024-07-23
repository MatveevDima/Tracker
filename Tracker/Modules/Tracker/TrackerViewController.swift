//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 22.07.2024.
//

import UIKit

final class TrackerViewController : UIViewController {
    
    private lazy var addButton: UIBarButtonItem = {
        let buttonImage = UIImage(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let addButton = UIBarButtonItem(
            image: buttonImage,
            style: .plain,
            target: TrackerViewController.self,
            action: #selector(didTapAddButton)
        )
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(didChangeSelectedDate), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()
    
    private lazy var placeholderPic = UIImageView(image: UIImage(named: "tracker_placeholder"))
    
    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: setupView
    private func setupView() {
        setupSuperview()
        setupNavBar()
        setupPlaceholder()
    }
    
    private func setupSuperview() {
        
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .white
    }
    
    private func setupNavBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.title = "Трекеры"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = addButton
        
        addButton.tintColor = UIColor(named: "Black")
        addButton.target = self
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120),
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
    
    // MARK: Actions
    @objc
    private func didTapAddButton() {
        
    }
    
    @objc
    private func didChangeSelectedDate() {
        
    }
}
