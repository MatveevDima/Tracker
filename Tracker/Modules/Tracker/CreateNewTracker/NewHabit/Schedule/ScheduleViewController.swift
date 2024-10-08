//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 28.07.2024.
//

import UIKit

final class ScheduleViewController : UIViewController {
    
    weak var delegate: CreateNewHabitProtocol?
    var selectedDays: Set<WeekDay> = []
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = NSLocalizedString("Schedule", comment: "")
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = .black
        return headerLabel
    }()
    
    private lazy var scheduleTable: UITableView = {
        let scheduleTable = UITableView(frame: .zero)
        scheduleTable.translatesAutoresizingMaskIntoConstraints = false
        
        scheduleTable.register(ScheduleTableCell.self, forCellReuseIdentifier: ScheduleTableCell.identifier)
        scheduleTable.isScrollEnabled = false
        scheduleTable.layer.masksToBounds = true
        scheduleTable.layer.cornerRadius = 16
        scheduleTable.allowsMultipleSelection = false
        
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
        
        return scheduleTable
    }()
    
    private lazy var completeButton: UIButton = {
        let completeButton = UIButton(type: .custom)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.backgroundColor = .black
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        completeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        completeButton.layer.cornerRadius = 16
        completeButton.layer.masksToBounds = true
        
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        
        return completeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Actions
    @objc
    private func didTapCompleteButton() {
        delegate?.setPickedSchedule(selectedDays)
        dismiss(animated: true)
    }
    
    // MARK: setupView
    private func setupView() {
        
        view.backgroundColor = .white
        
        setupHeaderLabel()
        setupScheduleTable()
        setupCompleteButton()
    }
    
    func setupHeaderLabel() {
        
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupScheduleTable() {
        
        view.addSubview(scheduleTable)
        
        NSLayoutConstraint.activate([
            scheduleTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scheduleTable.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupCompleteButton() {
        
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.identifier, for: indexPath) as? ScheduleTableCell else {
               return UITableViewCell()
           }
           
           let day = WeekDay.allCases[indexPath.row]
           cell.day = day
           cell.isDaySelected = selectedDays.contains(day)
           cell.delegate = self
           
           return cell
       }
}

    // MARK: UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    // MARK: CreateNewHabitDelegate
extension ScheduleViewController: CreateNewHabitDelegate {
    
}

// MARK: - ScheduleTableCellDelegate
extension ScheduleViewController: ScheduleTableCellDelegate {
    func didToggleSwitch(day: WeekDay, isOn: Bool) {
        if isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}
