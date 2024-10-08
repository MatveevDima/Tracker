//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 28.07.2024.
//

import UIKit

final class ScheduleTableCell: UITableViewCell {
    
    static let identifier = "ScheduleTableCell"
    
    weak var delegate: ScheduleTableCellDelegate?
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = .systemFont(ofSize: 16)
        dayLabel.textColor = .black
        return dayLabel
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
        toggleSwitch.onTintColor = .blue
        return toggleSwitch
    }()
    
    var day: WeekDay? {
        didSet {
            dayLabel.text = NSLocalizedString(day!.rawValue.capitalizeFirstLetter(), comment: "")
        }
    }
    
    var isDaySelected: Bool {
        get {
            return toggleSwitch.isOn
        }
        set {
            toggleSwitch.isOn = newValue
        }
    }
    
    @objc
    private func didToggleSwitch() {
        if let day = day {
                  delegate?.didToggleSwitch(day: day, isOn: toggleSwitch.isOn)
              }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        contentView.backgroundColor = UIColor(named: "light_gray_for_background")
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
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

