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
    case WelcomeAnimationOn
    case MultiplayerName
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


protocol StoreProvider {}

extension StoreProvider {
    
    func storeColorCatched(_ catched: Catched) {
        var catchedObject = self.retrieveColorCatched()
        guard !catchedObject.contains(where: { ($0.hex == catched.hex)}) else { return }
        var catched = catched
        LocationManager.shared.getCurrentPlace({ (location) in
            catched.location = location
            catchedObject.append(catched)
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(catchedObject), forKey: StoreKeys.ColorCatched.rawValue)
            } catch {
                Logger("Can't update catched colors!")
            }
        })
    }
    
    func retrieveColorCatched() -> [Catched] {
        do {
            guard let storedObject: Data = UserDefaults.standard.object(forKey: StoreKeys.ColorCatched.rawValue) as? Data else {
                return []
            }
            return try PropertyListDecoder().decode([Catched].self, from: storedObject)
        } catch {
            Logger("Catched colors not found!")
            return []
        }
    }

    func reset() {
        UserDefaults.standard.set([], forKey: StoreKeys.ColorCatched.rawValue)
    }
    
    func firstLaunchReset() {
        UserDefaults.standard.set([], forKey: StoreKeys.ColorCatched.rawValue)
        setWelcomeAnimation(true)
        setMultiplayerName(UIDevice.current.name.multiplayerName)
    }
    
    func isFirstLaunch() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: StoreKeys.FirstLaunch.rawValue) as? Bool {
            return false
        }
        UserDefaults.standard.setValue(false, forKey: StoreKeys.FirstLaunch.rawValue)
        return true
    }
    
    func setWelcomeAnimation(_ on: Bool) {
        UserDefaults.standard.set(on, forKey: StoreKeys.WelcomeAnimationOn.rawValue)
    }
    
    func isWelcomeAnimationOn() -> Bool {
        return UserDefaults.standard.object(forKey: StoreKeys.WelcomeAnimationOn.rawValue) as? Bool ?? true
    }

    func setMultiplayerName(_ name: String) {
        UserDefaults.standard.set(name, forKey: StoreKeys.MultiplayerName.rawValue)
    }
    
    func getMultiplayerName() -> String {
        return UserDefaults.standard.object(forKey: StoreKeys.MultiplayerName.rawValue) as? String ?? UIDevice.current.name.multiplayerName
    }

}

