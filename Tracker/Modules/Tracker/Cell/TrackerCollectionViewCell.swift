//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 23.07.2024.
//

import UIKit

final class TrackerCollectionViewCell : UICollectionViewCell {
    
    private var trackerId: UUID?
    private var isCompleted: Bool?
    private var counter: Int?
    
    private lazy var backgroundRect: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(named: "light_green")
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.text = "Название трекера"
        nameLabel.numberOfLines = 2
        return nameLabel
    }()
    
    
    private lazy var emojiView: UIView = {
       let emojiView = UIView()
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.backgroundColor = UIColor(named: "Background")
        emojiView.layer.masksToBounds = true
        emojiView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return emojiView
    }()
    
    private lazy var emojiLabel: UILabel = {
       let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emojiLabel.text = "😊"
        return emojiLabel
    }()
    
    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.text = "0 Дней"
        counterLabel.font = .systemFont(ofSize: 12, weight: .medium)
        counterLabel.textColor = .black
        return counterLabel
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "light_green")
        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        
        button.addTarget(self,
                         action: #selector(didTapCompleteButton),
                         for: .touchDown)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])
        return button
    }()
    
    private lazy var buttonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(with tracker: Tracker) {
            trackerId = tracker.id
            nameLabel.text = tracker.name
            emojiLabel.text = tracker.emoji
            backgroundRect.backgroundColor = UIColor(cgColor: tracker.color)
            completeButton.backgroundColor = UIColor(cgColor: tracker.color)
            configureCounterLabel(days: 0)
            isCompleted = false
        }
    
    // MARK: Actions
    @objc
    func didTapCompleteButton() {
        var days = counter ?? 0
        
        if (isCompleted == true) {
            completeButton.layer.opacity = 1
            buttonImage.image = UIImage(systemName: "plus")
            isCompleted = false
            days-=1
        } else {
            completeButton.layer.opacity = 0.3
            buttonImage.image = UIImage(systemName: "checkmark")
            isCompleted = true
            days+=1
        }
        configureCounterLabel(days: days)
    }
    
    func configureCounterLabel(days: Int) {
        self.counter = days
        counterLabel.text = "\(days) Дней"
    }
    
    // MARK: Setup View
    func setupView() {
        setupBackgroundRect()
        setupEmojiView()
        setupNameLabel()
        setupCounterLabel()
        setupCompleteButton()
    }
    
    func setupBackgroundRect() {
        
        contentView.addSubview(backgroundRect)
        
        NSLayoutConstraint.activate([
            backgroundRect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundRect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundRect.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    func setupEmojiView() {
        
        emojiView.addSubview(emojiLabel)
        backgroundRect.addSubview(emojiView)
        
        NSLayoutConstraint.activate([
            emojiView.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: backgroundRect.topAnchor, constant: 12),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
        ])
    }
    
    func setupNameLabel() {
        
        backgroundRect.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundRect.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: backgroundRect.bottomAnchor, constant: -12),
        ])
    }
    
    func setupCounterLabel() {
        
        contentView.addSubview(counterLabel)
        
        NSLayoutConstraint.activate([
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.topAnchor.constraint(equalTo: backgroundRect.bottomAnchor, constant: 16),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }
    
    func setupCompleteButton() {
        
        contentView.addSubview(completeButton)
        completeButton.addSubview(buttonImage)
        
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.topAnchor.constraint(equalTo: backgroundRect.bottomAnchor, constant: 8),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonImage.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
        ])
    }
}
