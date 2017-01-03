//
//  HTTPRequest.swift
//  CCCB Lighter
//
//  Created by mxa on 03.01.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation

class HTTPRequest {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func GET(urlString: String, completion: ((String) -> ())?) {
        guard let url = URL(string: urlString) else { return }
        
        let task = self.session.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let body = String(data: data, encoding: String.Encoding.utf8)
                else { return }
            completion?(body)
        }
        task.resume()
        
    }
    
}
