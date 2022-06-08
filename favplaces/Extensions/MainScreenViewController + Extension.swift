//
//  MainScreenViewController + Extension.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit

//MARK: - Setup search controller

extension MainScreenViewController: UISearchResultsUpdating {
    
    func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        let places = viewModel.arrayOfPlaces()
        filteredPlaces = places.filter({ $0.name.contains(searchText) })
        mainScreenView.tableView.reloadData()
    }
}
