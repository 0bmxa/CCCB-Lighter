//
//  DaliConnector.swift
//  CCCB Lighter
//
//  Created by mxa on 03.01.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation


class DaliConnector {
    
    private static let daliURL = "http://dali.club.berlin.ccc.de/cgi-bin/licht.cgi"
    
    
    // Getter for a single lamp
    class func lampValues(completion: @escaping (Int, Int, Int, Int) -> ()) {
        
        let request = HTTPRequest()
        request.GET(urlString: daliURL) { response in
            
            let components = response.replacingOccurrences(of: "\r\n", with: "").components(separatedBy: " ")
            guard components.count == 4 else { return }
            
            guard
                let lamp0Value = Int(components[0]),
                let lamp1Value = Int(components[1]),
                let lamp2Value = Int(components[2]),
                let lamp3Value = Int(components[3])
                else {
                    print("Invalid response.")
                    return
            }
            
            completion(lamp0Value, lamp1Value, lamp2Value, lamp3Value)
        }
        
    }
    
    
    // Convenience getter for all lamps
    class func averageLampValue(completion: @escaping (Int) -> ()) {
        self.lampValues { lamp0Value, lamp1Value, lamp2Value, lamp3Value in
            let averageLampValue = (lamp0Value + lamp1Value + lamp2Value + lamp3Value) / 4
            completion(averageLampValue)
        }
    }
    
    
    
    // Setter for a single lamp
    class func setLamp(_ lampID: Int, to lampValue: Int, completion: @escaping () -> ()) {
        let request = HTTPRequest()
        
        let lampID = -1
        let urlString = daliURL + "?set%20\(lampID)%20to%20\(lampValue)"
        
        request.GET(urlString: urlString) { _ in
            completion()
        }
    }
    
    // Convenience setter for all lamps
    class func setAllLamps(to lampValue: Int, completion: @escaping () -> ()) {
        let lampID = -1
        self.setLamp(lampID, to: lampValue, completion: completion)
    }
    
}
