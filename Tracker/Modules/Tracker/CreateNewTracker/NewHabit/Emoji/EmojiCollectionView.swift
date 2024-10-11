//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 30.07.2024.
//

import UIKit

final class EmojiCollectionView: UIView {
    
    weak var delegate: CreateNewHabitProtocol?
    
    private let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private var selectedEmojiIndex: IndexPath?
    private var selectedEmoji: String?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(EmojiCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiCollectionHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func selectByEmoji(_ emoji: String) {
        selectedEmoji = emoji
    }
}

extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
        let emoji = emojis[indexPath.item]
        cell.configure(with: emoji)
        if(selectedEmoji == emoji) {
            cell.setSelected(true)
        }
        return cell
    }
}

extension EmojiCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (selectedEmojiIndex == nil && selectedEmoji != nil) {
            for cell in collectionView.visibleCells {
                if let myCell = cell as? EmojiCollectionViewCell {
                    myCell.setSelected(false)
                }
            }
        }
        
        if let previousIndex = selectedEmojiIndex {
            let previousCell = collectionView.cellForItem(at: previousIndex) as? EmojiCollectionViewCell
            previousCell?.setSelected(false)
        }
        
        selectedEmojiIndex = indexPath
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! EmojiCollectionViewCell
        selectedCell.setSelected(true)
        
        selectedEmoji = emojis[indexPath.item]
        delegate?.setPickedEmoji(selectedEmoji)
    }
}

extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiCollectionHeaderView.identifier, for: indexPath) as? EmojiCollectionHeaderView else {
            fatalError("Invalid view type")
        }
        header.configure(with: "Emoji")
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 7 * 5
        let totalSpacing: CGFloat = 20 + padding // 10 left + 10 right + 7*5 between items
        let availableWidth = collectionView.frame.width - totalSpacing
        let width = availableWidth / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

extension EmojiCollectionView : CreateNewHabitDelegate {}
