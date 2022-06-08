//
//  PlaceViewModel.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import RealmSwift

class PlaceViewModel {
    
    private let model: PlaceModel
        
    var currentPlace: DBObject?
        
    init(model: PlaceModel) {
        self.model = model
    }
    
    func savePlace(name: String, location: String?, type: String?, image: UIImage, rating: Double) {
        
        let imageData = image.pngData()
        
        let newPlace = DBObject(name: name,
                             location: location,
                             type: type,
                             imageData: imageData,
                             rating: rating)
        
        if currentPlace != nil {
            let realm = try! Realm()
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            model.savePlace(newPlace)
        }
    }
    
    func getCurrentPlace() {
        currentPlace = model.getCurrentPlace()
    }
    
    func getMainScreenViewModel() -> MainScreenViewModel {
        return MainScreenViewModel(model: model.getMainScreenModel())
    }
    
    func getMapScreenViewModel() -> MapScreenViewModel {
        return MapScreenViewModel(model: model.getMapScreenModel())
    }
}
