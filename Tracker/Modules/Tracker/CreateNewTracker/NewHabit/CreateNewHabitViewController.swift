//
//  CreateNewHabitViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 25.07.2024.
//

import UIKit

final class CreateNewHabitViewController : UIViewController {
    
    weak var delegate: CreateNewTrackerProtocol? 
    
    private var settings: [SettingsOptions] = []
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Новая привычка"
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = .black
        return headerLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
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
    
    private lazy var textFieldErrorMessageContainer: UIView = {
        let textFieldErrorMessageContainer = UIView()
        textFieldErrorMessageContainer.translatesAutoresizingMaskIntoConstraints = false
        textFieldErrorMessageContainer.isHidden = true
        return textFieldErrorMessageContainer
    }()
    
    private lazy var textFieldErrorMessage: UILabel = {
        let errorMessage = UILabel()
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessage.textColor = UIColor(named: "light_red_for_cancel_button")
        errorMessage.font = .systemFont(ofSize: 17, weight: .medium)
        errorMessage.text = "Ограничение 38 символов"
        
        return errorMessage
    }()
    
    private lazy var settingsTable: UITableView = {
        let settingsTable = UITableView(frame: .zero)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        settingsTable.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        settingsTable.isScrollEnabled = false
        settingsTable.layer.masksToBounds = true
        settingsTable.layer.cornerRadius = 16
        
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
        return settingsTable
    }()
    
    private lazy var stackForButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "light_red_for_cancel_button"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderColor = (UIColor(named: "light_red_for_cancel_button") ?? .red).cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Создать", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .lightGray
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        return cancelButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendSettingsToList()
        setupView()
    }
    
    // MARK: - Actions
    @objc private func didChangeTitleTextField() {
        
        if ((textField.text ?? "").count > 38) {
            textFieldErrorMessageContainer.isHidden = false

        } else {
            textFieldErrorMessageContainer.isHidden = true
      
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
        delegate?.didCancelCreatingNewHabit()
    }
    
    // MARK: Setup
    func setupView() {
        
        view.backgroundColor = .white
        
        setupHeaderLabel()
        setupScrollView()
        setupStackView()
        setupTextField()
        setupTablelView()
        setupButtons()
    }
    
    func setupHeaderLabel() {
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupScrollView() {
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 14),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupStackView() {
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])
    }
    
    func setupTextField() {
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(textFieldErrorMessageContainer)
        
        textFieldErrorMessageContainer.addSubview(textFieldErrorMessage)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 24),
            textFieldErrorMessage.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            textFieldErrorMessage.centerXAnchor.constraint(equalTo: textFieldErrorMessageContainer.centerXAnchor),
        ])
    }
    
    func setupTablelView() {
        
        stackView.addArrangedSubview(settingsTable)
        
        NSLayoutConstraint.activate([
            settingsTable.heightAnchor.constraint(equalToConstant: 150),
            settingsTable.topAnchor.constraint(equalTo: textFieldErrorMessage.bottomAnchor, constant: 24),
            settingsTable.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
    
    func setupButtons() {
        
        stackForButtons.addArrangedSubview(cancelButton)
        stackForButtons.addArrangedSubview(createButton)
        
        stackView.addArrangedSubview(stackForButtons)
        
        NSLayoutConstraint.activate([
            stackForButtons.heightAnchor.constraint(equalToConstant: 60),
            stackForButtons.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -8),
            stackForButtons.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 4),
            stackForButtons.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -4),
            stackForButtons.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8)
        ])
    }
    
    private func appendSettingsToList() {
        
        settings.append(
            SettingsOptions(
                name: "Категория",
                pickedParameter: nil,// isEdit ? pickedCategory?.name : nil,
                handler: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.setCategory()
                }
            ))
     //   if isHabit {
            settings.append(
                SettingsOptions(
                    name: "Расписание",
                    pickedParameter: nil,
                    handler: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.setSchedule()
                    }
                ))
//            if isEdit {
//                didConfigure(schedule: (tracker?.schedule!.schedule)!)
//            }
   //     }
        
    }
    
    private func setCategory() {
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
        present(categoryViewController, animated: true)
    }
    
    private func setSchedule() {
        
    }
}

    // MARK: UITableViewDataSource
extension CreateNewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier)
        else { return UITableViewCell() }
        
        cell.textLabel?.text = settings[indexPath.row].name
        cell.detailTextLabel?.text = settings[indexPath.row].pickedParameter
        
        return cell
    }
}

    // MARK: UITableViewDelegate
extension CreateNewHabitViewController: UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
}

    // MARK: CreateNewTrackerDelegate
extension CreateNewHabitViewController: CreateNewTrackerDelegate {
  
    
}
    // MARK: CreateNewHabitProtocol
extension CreateNewHabitViewController: CreateNewHabitProtocol {
  
    
}
