//
//  StoreProvider.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit


enum StoreKeys: String {

    case Level
    
}

protocol StoreProvider {
    func storeLevelUp()
    func retrieveLevel() -> Int
    func reset()
}

extension StoreProvider {
    
    func storeLevelUp() {
        var level = self.retrieveLevel()
        level += 1
        UserDefaults.standard.setValue(level, forKey: StoreKeys.Level.rawValue)
    }
    
    func retrieveLevel() -> Int {
        if let value = UserDefaults.standard.value(forKey: StoreKeys.Level.rawValue) as? Int {
            return value
        }
        return 0
    }

    func reset() {
        UserDefaults.standard.setValue(0, forKey: StoreKeys.Level.rawValue)
    }
    
}

