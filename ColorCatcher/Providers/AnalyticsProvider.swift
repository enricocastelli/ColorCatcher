//
//  AnalyticsProvider.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 29/11/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import Firebase

protocol AnalyticsProvider {}

extension AnalyticsProvider {
    
    func logEvent(_ event: Event, parameters: [String: String]? = nil) {
        #if !DEBUG
        Analytics.logEvent(event.rawValue, parameters: parameters)
        Logger(event, parameters)
        #endif
    }
    
}
