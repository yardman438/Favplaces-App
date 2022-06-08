//
//  MainScreenViewModel.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import Foundation

class MainScreenViewModel {
    
    private let model: MainScreenModel
    
    var places = [DBObject]()
    private var currentPlace: DBObject?
        
    init(model: MainScreenModel) {
        self.model = model
    }
    
    func numberOfPlaces() -> Int {
        return places.count
    }
    
    func getPlaces(completion: @escaping (_ hasPlacesUpdated: Bool) -> Void) {
        
        model.getPlaces { [weak self] (places) in
            
            guard let self = self, let places = places else { return }
            self.places = places
            completion(true)
        }
    }
    
    func place(at index: Int) -> DBObject {
        let place = places[index]
        return place
    }
    
    func arrayOfPlaces() -> [DBObject] {
        return places
    }
    
    func deletePlace(at indexPath: IndexPath) {
        let place = places[indexPath.row]
        model.deletePlace(place)
        
        places.remove(at: indexPath.row)
    }
    
    func setCurrentPlace(_ selectedPlace: DBObject?) {
        currentPlace = selectedPlace
        model.setCurrentPlace(selectedPlace)
    }
    
    func sorting(segmentIndex: Int, acsendingSorting: Bool) -> [DBObject] {
        
//        if segmentIndex == 0 {
//            places = places.sorted(byKeyPath: "date", ascending: acsendingSorting)
//        } else {
//            places = places.sorted(byKeyPath: "name", ascending: acsendingSorting)
//        }
        
        return places
    }
    
    func getPlaceViewModel() -> PlaceViewModel {
        return PlaceViewModel(model: model.getPlaceModel())
    }
}
