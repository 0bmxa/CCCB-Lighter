//
//  ViewController.swift
//  CCCB Lighter
//
//  Created by mxa on 03.01.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let daliURL = "http://dali.club.berlin.ccc.de/cgi-bin/licht.cgi"

    @IBOutlet weak var allLampsSlider: NSSlider?
    @IBOutlet weak var allLampsValueLabel: NSTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.allLampsSlider?.minValue = 150
        self.allLampsSlider?.maxValue = 255
        self.updateUI()
    }

    /*
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    */

    @IBAction func allLampsSliderChanged(_ sender: NSSlider) {
        let sliderValue = sender.integerValue
        self.lampValueChanged(value: sliderValue)
    }

}

private extension ViewController {
    
    func lampValueChanged(value lampValue: Int) {
        DaliConnector.setAllLamps(to: lampValue) {
            self.updateUI()
        }
    }
    
    func updateUI() {
        DaliConnector.averageLampValue { averageLampValue in
            // Slider
            self.allLampsSlider?.integerValue = averageLampValue
            
            // Label
            let percentage = (Double(averageLampValue)/255.0 * 100.0).rounded()
            self.allLampsValueLabel?.stringValue = "\(percentage) %"
        }
    }
    
}


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
