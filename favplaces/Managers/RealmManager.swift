//
//  RealmManager.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import RealmSwift

protocol DBProvider {
    func saveObject(_ place: DBObject)
    func deleteObject(_ place: DBObject)
    func getPlaces(completion: @escaping (_ places: [DBObject]?) -> Void)
}

class RealmManager: DBProvider {
    
    // Schema version for update DB
    let schemaVersion: UInt64 = 3
    
    // Save new place
    func saveObject(_ place: DBObject) {
        
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let config = Realm.Configuration(schemaVersion: self.schemaVersion)
                    Realm.Configuration.defaultConfiguration = config
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(place)
                        realm.refresh()
                    }
                } catch {
                    print("Error: Can't save the object")
                }
            }
        }
    }
    
    // Delete place from DB
    func deleteObject(_ place: DBObject) {
        
        DispatchQueue.global(qos: .background).sync {
            do {
                let config = Realm.Configuration(schemaVersion: self.schemaVersion)
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(place)
                    realm.refresh()
                }
            } catch {
                print("Error: Can't delete the object")
            }
        }
    }
    
    // Download places from DB
    func getPlaces(completion: @escaping (_ places: [DBObject]?) -> Void) {
        
        DispatchQueue.global(qos: .background).sync {
            do {
                let config = Realm.Configuration(schemaVersion: schemaVersion)
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                let results = realm.objects(DBObject.self)
                realm.refresh()
                completion(Array(results))
            } catch {
                print("Error: Can't download places fro DB")
            }
        }
    }
}
