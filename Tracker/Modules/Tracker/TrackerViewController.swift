//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий Матвеев on 22.07.2024.
//

import UIKit

final class TrackerViewController : UIViewController {
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerStore = TrackerStore.shared
    private var filteredData: [TrackerCategory] = []
    
    private let widthParameters = CollectionParameters(
        cellsNumber: 2,
        leftInset: 16,
        rightInset: 16,
        interCellSpacing: 10
    )
    
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
        return collectionView
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
        setupCollectionView()
        setupPlaceholder()
        fetchCategories()
        updateView()
    }
    
    private func setupSuperview() {
        
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .white
    }
    
    private func setupNavBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.title = NSLocalizedString("Trackers", comment: "")
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = addButton
        
        addButton.tintColor = UIColor(named: "Black")
        addButton.target = self
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
        
        searchController.searchResultsUpdater = self
        
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
        
        placeholderPic.isHidden = true
        placeholderText.isHidden = true
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: Actions
    @objc
    private func didTapAddButton() {
        let viewController = CreateNewTrackerViewController()
        viewController.trackerViewController = self
        present(viewController, animated: true)
    }
    
    @objc
    private func didChangeSelectedDate() {
        collectionView.reloadData()
    }
    
    private func updateView() {
        if categories.isEmpty {
            placeholderPic.isHidden = false
            placeholderText.isHidden = false
            collectionView.isHidden = true
        } else {
            placeholderPic.isHidden = true
            placeholderText.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
}
// MARK: UICollectionViewDataSource
extension TrackerViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData[section].trackers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrackerCollectionViewCell
        
        let tracker = filteredData[indexPath.section].trackers[indexPath.row]
        cell.configure(with: tracker)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let trackerHeader = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCollectionViewHeader.identifier, for: indexPath) as? TrackerCollectionViewHeader
        else {
            preconditionFailure("Failed to cast UICollectionReusableView as TrackerCollectionViewHeader")
        }
        let category = filteredData[indexPath.section]
        trackerHeader.configure(model: category)
        return trackerHeader
    }
}

// MARK: UICollectionViewDelegate
extension TrackerViewController : UICollectionViewDelegate {
    
    
}

// MARK: UISearchResultsUpdating
extension TrackerViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        categories = trackerCategoryStore.getCategories()
        
        if let text = searchController.searchBar.text {
            if text.count > 0 {
                var searchedCategories: Array<TrackerCategory> = []
                for category in categories {
                    var searchedTrackers: Array<Tracker> = []
                    
                    for tracker in category.trackers {
                        if tracker.name.localizedCaseInsensitiveContains(text)
                         //   && isTrackerScheduledOnSelectedDate(tracker)
                        {
                            searchedTrackers.append(tracker)
                        }
                    }
                    if !searchedTrackers.isEmpty {
                        searchedCategories.append(TrackerCategory(id: UUID(), name: category.name, trackers: searchedTrackers))
                    }
                }
                filteredData = searchedCategories
                
            } else {
                filteredData = getAndFilterTrackersBySelectedDate()
            }
        } else {
            filteredData = getAndFilterTrackersBySelectedDate()
        }
        collectionView.reloadData()
    }
    
    private func getAndFilterTrackersBySelectedDate() -> [TrackerCategory] {

        self.categories = trackerCategoryStore.getCategories()

        return categories.filter {e in !e.trackers.isEmpty}
    }
}


// MARK: UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - widthParameters.widthInsets
        let cellWidth = availableWidth / CGFloat(widthParameters.cellsNumber)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: widthParameters.leftInset, bottom: 8, right: widthParameters.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let targetSize = CGSize(width: collectionView.bounds.width, height: 42)
        
        return headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
}
// MARK: TrackerViewControllerProtocol
extension TrackerViewController : TrackerViewControllerProtocol {
    
    
    func didCreateNewTracker() {
        fetchCategories()
        updateView()
    }
    
    private func fetchCategories() {
        categories = trackerCategoryStore.getCategories().filter {e in !e.trackers.isEmpty}
        filteredData = categories
        collectionView.reloadData()
    }
}

// MARK: - TrackerCollectionViewCellDelegate

extension TrackerViewController: TrackerCollectionViewCellDelegate {
    
    func markComplete(with id: UUID) {
//
//        guard selectedDate <= Date() else {
//            return
//        }
//        guard let date = selectedDate.omitTime() else { return }
//        trackerRecordStore.saveTrackerRecordCoreData(TrackerRecord(trackerId: id, date: date))
//        completedRecords = trackerRecordStore.getCompletedTrackers()
//        updateCollectionView()
    }

    func undoMarkComplete(with id: UUID) {
        
//        guard selectedDate <= Date() else {
//            return
//        }
//        guard let date = selectedDate.omitTime() else { return }
//        if completedRecords.contains(where: { $0.trackerId == id && Calendar.current.isDate($0.date, equalTo: date, toGranularity: .day)}) {
//            trackerRecordStore.deleteTrackerRecord(with: id, on: date)
//        }
//        completedRecords = trackerRecordStore.getCompletedTrackers()
//        updateCollectionView()
    }
    
    func pinTracker(withId id: UUID) {
        
//        trackerStore.pinTracker(withId: id)
//        self.completedRecords = self.trackerRecordStore.getCompletedTrackers()
//        filteredData = getAndFilterTrackersBySelectedDate()
//        updateCollectionView()
    }

    func deleteTracker(withId id: UUID) {
        
        let actionSheet: UIAlertController = {
            let alert = UIAlertController()
            alert.title = NSLocalizedString("Delete tracker confirmation", comment: "")
            return alert
        }()
        let action1 = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) {_ in
            
            self.trackerStore.deleteTracker(withId: id)
            //self.completedRecords = self.trackerRecordStore.getCompletedTrackers()
            self.filteredData = self.getAndFilterTrackersBySelectedDate()
            self.collectionView.reloadData()
        }
        let action2 = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) {_ in}
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        present(actionSheet, animated: true)
    }

    func editTracker(withId id: UUID) {
        
        let trackerCoreData = trackerStore.fetchTrackerWithId(id)
        let tracker = trackerStore.convertToTracker(coreDataTracker: trackerCoreData)
        
        let viewController = CreateNewHabitViewController()
        
        if tracker.schedule?.count == 7 {
            viewController.isHabit = false
        } else {
            viewController.isHabit = true
        }

        viewController.isEdit = true
        viewController.tracker = trackerCoreData

        present(viewController, animated: true)
    }
}
