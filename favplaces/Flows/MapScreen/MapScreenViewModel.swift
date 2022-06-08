//
//  MapScreenViewModel.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import Foundation

class MapScreenViewModel {
    
    private let model: MapScreenModel
    
    var currentPlace: DBObject?
    
    init(model: MapScreenModel) {
        self.model = model
    }
    
    func getCurrentPlace() {
        currentPlace = model.getCurrentPlace()
    }
    
    func getPlaceViewModel() -> PlaceViewModel {
        return PlaceViewModel(model: model.getPlaceModel())
    }
    
}
