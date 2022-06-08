//
//  MapScreenModel.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import Foundation

class MapScreenModel {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getCurrentPlace() -> DBObject? {
        return repository.getCurrentPlace()
    }
    
    func getPlaceModel() -> PlaceModel {
        return PlaceModel(repository: repository)
    }
    
}
