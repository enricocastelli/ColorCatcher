//
//  StoreProvider.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


enum StoreKeys: String {

    case ColorCatched
    case FirstLaunch
    case isFirstRace
    case isFirstDiscovery
}

struct Catched: Codable {
    
    let hex: String
    let date: Date
    var location: String?
    
    init(hex: String) {
        self.hex = hex
        date = Date()
    }
}

struct CatchedObject: Codable {
    
    var index: Int
    var catched: [Catched]
    
    static func empty() -> CatchedObject {
        return CatchedObject(index: 0, catched: [])
    }
}

protocol StoreProvider {
    func storeColorCatched(_ catched: Catched)
    func retrieveColorCatched() -> CatchedObject
    func reset()
    func isFirstLaunch() -> Bool
    func isFirtRace() -> Bool
    func isFirtDiscovery() -> Bool
}

extension StoreProvider {
    
    func storeColorCatched(_ catched: Catched) {
        var catchedObject = self.retrieveColorCatched()
        catchedObject.index += 1
        var catched = catched
        LocationManager.shared.getCurrentPlace({ (location) in
            catched.location = location
            catchedObject.catched.append(catched)
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(catchedObject), forKey: StoreKeys.ColorCatched.rawValue)
            } catch {
                Logger("Can't update catched colors!")
            }
        })
    }
    
    func retrieveColorCatched() -> CatchedObject {
        do {
            guard let storedObject: Data = UserDefaults.standard.object(forKey: StoreKeys.ColorCatched.rawValue) as? Data else {
                return CatchedObject.empty()
            }
            return try PropertyListDecoder().decode(CatchedObject.self, from: storedObject)
        } catch {
            Logger("Catched colors not found!")
            return CatchedObject.empty()
        }
    }

    func reset() {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(CatchedObject.empty()), forKey: StoreKeys.ColorCatched.rawValue)
        } catch {
            Logger("Can't update catched colors!")
        }
    }
    
    func isFirstLaunch() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: StoreKeys.FirstLaunch.rawValue) as? Bool {
            return false
        }
        UserDefaults.standard.setValue(false, forKey: StoreKeys.FirstLaunch.rawValue)
        return true
    }
    
    func isFirtRace() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: StoreKeys.isFirstRace.rawValue) as? Bool {
            return false
        }
        UserDefaults.standard.setValue(true, forKey: StoreKeys.isFirstRace.rawValue)
        return true
    }
    
    func isFirtDiscovery() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: StoreKeys.isFirstDiscovery.rawValue) as? Bool {
            return false
        }
        UserDefaults.standard.setValue(true, forKey: StoreKeys.isFirstDiscovery.rawValue)
        return true
    }
    
}

