//
//  MainScreenModel.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import Foundation

class MainScreenModel {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getPlaces(completion: @escaping (_ places: [DBObject]?) -> Void) {
        repository.getPlaces { (places) in
            completion(places)
        }
    }
    
    func deletePlace(_ place: DBObject) {
        repository.deletePlace(place)
    }
    
    func setCurrentPlace(_ place: DBObject?) {
        repository.setCurrentPlace(place)
    }
    
    func getPlaceModel() -> PlaceModel {
        return PlaceModel(repository: repository)
    }
}
