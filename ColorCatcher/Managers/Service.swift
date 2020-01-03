//
//  Service.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit
import Firebase

class Service: NSObject, URLSessionDelegate {
    
    static var shared = Service()
    var session: URLSession {
        get {
            return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        }
    }
    
    private func remoteConfig() -> RemoteConfig {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        return remoteConfig
    }
    
    func get(success: @escaping ([ColorModel]) -> (), failure: @escaping (Error) -> ()) {
        let colors = remoteConfig().configValue(forKey: "Colors").dataValue
        do {
            success(try JSONDecoder().decode([ColorModel].self, from: colors))
        } catch {
            Logger(error)
            failure(error as NSError)
        }
    }
//
//    func get(success: @escaping ([ColorModel]) -> (), failure: @escaping (Error) -> ()) {
//        do {
//            let jsonMock = Bundle.main.path(forResource: "API", ofType: "json")
//            let dataMock = try Data(contentsOf: URL(fileURLWithPath: jsonMock!))
//            success(try JSONDecoder().decode([ColorModel].self, from: dataMock))
//        } catch {
//            Logger(error)
//            failure(error as NSError)
//        }
//    }
    
    func isSkippingEnabled() -> Bool {
        return remoteConfig().configValue(forKey: "isSkippingEnabled").boolValue
    }
    
    func getCredits() -> String {
        return remoteConfig().configValue(forKey: "credits").stringValue ?? "enricoappstelli@gmail.com"

    }
}
