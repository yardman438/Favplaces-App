//
//  PlaceModel.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import Foundation

class PlaceModel {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getCurrentPlace() -> DBObject? {
        return repository.getCurrentPlace()
    }
    
    func savePlace(_ place: DBObject) {
        repository.savePlace(place)
    }
    
    func getMainScreenModel() -> MainScreenModel {
        return MainScreenModel(repository: repository)
    }
    
    func getMapScreenModel() -> MapScreenModel {
        return MapScreenModel(repository: repository)
    }
}
