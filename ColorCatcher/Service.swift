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
    
    func get(success: @escaping (Data) -> (), failure: @escaping (Error) -> ()) {
        guard let url = URL(string: "https://github.com/enricocastelli/hermit/blob/master/README.md") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("text/markdown", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            print(data)
        })
        task.resume()
        
    }
}
