//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 30.07.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ColorCollectionViewCell"
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = .white
        colorView.layer.cornerRadius = 10
        colorView.layer.masksToBounds = true
        return colorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func setSelected(_ selected: Bool) {
        
        guard
            let colorViewBackgroundColor = colorView.backgroundColor
        else { return }
        contentView.layer.borderWidth = selected ? 1 : 0
        contentView.layer.borderColor = selected ?  colorViewBackgroundColor.cgColor : UIColor.clear.cgColor
    }
}

