//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 24.07.2024.
//

import UIKit

final class CreateNewTrackerViewController : UIViewController {
    
    weak var trackerViewController: TrackerViewControllerProtocol?
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = NSLocalizedString("Create a tracker", comment: "")
        headerLabel.font = .systemFont(ofSize: 16, weight: .black)
        return headerLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton(type: .custom)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.setTitle(NSLocalizedString("Habit", comment: ""), for: .normal)
        habitButton.setTitleColor(.white, for: .normal)
        habitButton.backgroundColor = .black
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        
        habitButton.addTarget(self, action: #selector(self.didTapHabitButton), for: .touchUpInside)
        
        return habitButton
    }()
    
    private lazy var eventButton: UIButton = {
        let eventButton = UIButton(type: .custom)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.setTitle(NSLocalizedString("Irregular action", comment: ""), for: .normal)
        eventButton.setTitleColor(.white, for: .normal)
        eventButton.backgroundColor = .black
        eventButton.layer.cornerRadius = 16
        eventButton.layer.masksToBounds = true
        return eventButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Actions
    @objc
    func didTapHabitButton() {
        let viewControlller = CreateNewHabitViewController()
        viewControlller.delegate = self
        present(viewControlller, animated: true)
    }
    
    
    // MARK: Setup
    func setupView() {
        
        view.backgroundColor = .white
        
        setupHeaderLabel()
        setupStackView()
        setupHabitButton()
        setupEventButton()
    }
    
    func setupHeaderLabel() {
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupStackView() {
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupHabitButton() {
        
        stackView.addArrangedSubview(habitButton)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupEventButton() {
        
        stackView.addArrangedSubview(eventButton)
        
        NSLayoutConstraint.activate([
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

    // MARK: TrackerViewControllerDelegate
extension CreateNewTrackerViewController: TrackerViewControllerDelegate {
    
    func didCreateNewTracker() {
        dismiss(animated: true)
        trackerViewController?.didCreateNewTracker()
    }
}

    // MARK: CreateNewTrackerProtocol
extension CreateNewTrackerViewController: CreateNewTrackerProtocol {
    
    func didCreateNewHabit() {
        self.didCreateNewTracker()
    }
    
    func didCancelCreatingNewHabit() {
        self.didCreateNewTracker()
    }
}
