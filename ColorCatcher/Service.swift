//
//  Service.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 27/02/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

class Service: NSObject, URLSessionDelegate {
    
    static var shared = Service()
    var session: URLSession {
        get {
            return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        }
    }
    
    func get(success: @escaping (ColorObjectModel) -> (), failure: @escaping (Error) -> ()) {
        guard let url = URL(string: "https://raw.githubusercontent.com/enricocastelli/ColorCatcher/master/colors.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    Logger("nil data")
                    failure(NSError(domain: "nil data", code: 500, userInfo: nil))
                    return
                }
                do {
                    success(try JSONDecoder().decode(ColorObjectModel.self, from: data))
//                    let jsonMock = Bundle.main.path(forResource: "Mock", ofType: "json")
//                    let dataMock = try Data(contentsOf: URL(fileURLWithPath: jsonMock!))
//                    success(try JSONDecoder().decode(ColorObjectModel.self, from: dataMock))
                } catch {
                    Logger(error.localizedDescription)
                    failure(error as NSError)
                }
            }
        })
        task.resume()
        
    }
}
