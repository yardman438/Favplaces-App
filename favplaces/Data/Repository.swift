//
//  Repository.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import Foundation
import RealmSwift

protocol RepositoryProtocol {
    
    func getPlaces(completion: @escaping (_ places: [DBObject]?) -> Void)
    func savePlace(_ place: DBObject)
    func deletePlace(_ place: DBObject)
    func setCurrentPlace(_ place: DBObject?)
    func getCurrentPlace() -> DBObject?
    
}

class Repository: RepositoryProtocol {
    
    private let dbProvider: DBProvider
    
    private var currentPlace: DBObject?
    
    init(realmManager: RealmManager = RealmManager()) {
        self.dbProvider = realmManager
    }
        
    
    func getPlaces(completion: @escaping ([DBObject]?) -> Void) {
        dbProvider.getPlaces { (places) in
            completion(places)
        }
    }
    
    func savePlace(_ place: DBObject) {
        dbProvider.saveObject(place)
    }
    
    func deletePlace(_ place: DBObject) {
        dbProvider.deleteObject(place)
    }
    
    func setCurrentPlace(_ place: DBObject?) {
        currentPlace = place
    }
    
    func getCurrentPlace() -> DBObject? {
        return currentPlace
    }
}
