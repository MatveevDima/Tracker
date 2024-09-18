//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 30.07.2024.
//

import UIKit

final class ColorCollectionView: UIView {
    
    weak var delegate: CreateNewHabitProtocol?
    
    private let colors: [UIColor] = [
        .ccRed, .ccOrange, .ccBlue, .ccPurple, .ccGreen, .ccPink,
        .ccNude, .ccLightBlue, .ccLightGreen, .ccDarkPurple, .ccDarkOrange, .ccLightPink,
        .ccBeige, .ccLilo, .ccDarkLilo, .ccDarkPink, .ccLightPurple, .ccDarkGreen
    ]
    
    private var selectedColorIndex: IndexPath?
    private var selectedColor: UIColor?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.register(ColorCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ColorCollectionHeaderView.identifier)
        
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
}

extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
        cell.configure(with: colors[indexPath.item])
        return cell
    }
}

extension ColorCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousIndex = selectedColorIndex {
            let previousCell = collectionView.cellForItem(at: previousIndex) as? ColorCollectionViewCell
            previousCell?.setSelected(false)
        }
        
        selectedColorIndex = indexPath
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
        selectedCell.setSelected(true)
        
        selectedColor = colors[indexPath.item]
        delegate?.setPickedColor(selectedColor)
    }
}

extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ColorCollectionHeaderView.identifier, for: indexPath) as? ColorCollectionHeaderView else {
            fatalError("Invalid view type")
        }
        header.configure(with: "Цвет")
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

extension ColorCollectionView : CreateNewHabitDelegate {}
