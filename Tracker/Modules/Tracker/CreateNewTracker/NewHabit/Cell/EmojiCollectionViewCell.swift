//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 30.07.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EmojiCollectionViewCell"
    
    public lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    func setSelected(_ selected: Bool) {
        contentView.backgroundColor = selected ? UIColor(named: "light_gray_for_background") ?? UIColor.lightGray : UIColor.clear
    }
}

