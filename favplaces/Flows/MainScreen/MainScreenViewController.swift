//
//  MainScreenViewController.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    let viewModel: MainScreenViewModel
    let mainScreenView = MainScreenView()
    
    //MARK: - Interface elements
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Properties
    
    var filteredPlaces: [DBObject]?
    private var acsendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //MARK: - Lifecycle
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupTableView()
        setupSearchController()
        
        DispatchQueue.main.async {
            self.mainScreenView.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPlaces { [weak self] (hasPlacesUpdated) in
            
            guard let self = self, hasPlacesUpdated else { return }
            
            DispatchQueue.main.async {
                self.mainScreenView.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainScreenView.tableView.frame = view.bounds
    }
    
    //MARK: - Methods
    
    @objc private func addButtonTapped() {
        
        viewModel.setCurrentPlace(nil)
        
        let placeVC = PlaceViewController(viewModel: viewModel.getPlaceViewModel())
        placeVC.incomeIdentifier = "addPlace"
        
        navigationController?.pushViewController(placeVC, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        
        let filterSettingsVC = FilterSettingsViewController()
        filterSettingsVC.modalPresentationStyle = .currentContext
        self.present(filterSettingsVC, animated: false)
    }
    
    @objc private func refreshTable() {
        updatePlaces()
    }
    
    private func updatePlaces() {
        
        viewModel.getPlaces { [weak self] (hasPlacesUpdated) in
            
            guard let self = self, hasPlacesUpdated else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self.mainScreenView.tableView.refreshControl?.endRefreshing()
                self.mainScreenView.tableView.reloadData()
            }
        }
    }
}

//MARK: - Setup UITableView

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        mainScreenView.tableView.delegate = self
        mainScreenView.tableView.dataSource = self
        
        mainScreenView.tableView.refreshControl = UIRefreshControl()
        mainScreenView.tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredPlaces != nil && isFiltering {
            return filteredPlaces?.count ?? viewModel.numberOfPlaces()
        }
        
        return viewModel.numberOfPlaces()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let place = isFiltering ? filteredPlaces![indexPath.row] : viewModel.place(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.identifier, for: indexPath) as! MainScreenTableViewCell
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.ratingLabel.text = "\(place.rating)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] contextualAction, view, boolValue in
            
            guard let self = self else { return }
            
            self.viewModel.deletePlace(at: indexPath)
            self.mainScreenView.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let placeVC = PlaceViewController(viewModel: viewModel.getPlaceViewModel())
        placeVC.incomeIdentifier = "editPlace"
        
        let navVC = UINavigationController(rootViewController: placeVC)
        navigationController?.present(navVC, animated: true)
        
        let place = isFiltering ? filteredPlaces![indexPath.row] : viewModel.place(at: indexPath.row)
        
        viewModel.setCurrentPlace(place)
    }
}

//MARK: - Setup interface

extension MainScreenViewController {
    
    private func setupInterface() {
        
        title = "My Places"
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "firstColor")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(filterButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "firstColor")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: nil,
                                                                action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "firstColor")
    }
}
