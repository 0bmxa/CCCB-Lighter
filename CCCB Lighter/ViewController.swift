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
        
        // Workaround to get key events in here
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event -> NSEvent? in
            self.keyUp(with: event)
            return event
        }
    }

    @IBAction func allLampsSliderChanged(_ sender: NSSlider?) {
        guard let sliderValue = self.allLampsSlider?.integerValue else { return }
        self.lampValueChanged(value: sliderValue)
    }
    
    override func keyUp(with event: NSEvent) {
        guard let keyChars = event.characters else { return }
        if keyChars.contains("-") {
            self.allLampsSlider?.integerValue -= 10
        } else if keyChars.contains("+") || keyChars.contains("=") {
            self.allLampsSlider?.integerValue += 10
        }
        
        self.allLampsSliderChanged(nil)
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

