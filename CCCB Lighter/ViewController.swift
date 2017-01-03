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
    @IBOutlet weak var touchBarAllLampsSlider: NSSlider?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.allLampsSlider?.minValue = 150
        self.allLampsSlider?.maxValue = 255
        self.touchBarAllLampsSlider?.minValue = 150
        self.touchBarAllLampsSlider?.maxValue = 255
        self.updateUI()
        
        // Workaround to get key events in here
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event -> NSEvent? in
            self.keyUp(with: event)
            return event
        }
    }
    
    
    // Action from UI slider
    @IBAction func allLampsSliderChanged(_ sender: NSSlider?) {
        guard let sliderValue = self.allLampsSlider?.integerValue else { return }
        self.lampValueChanged(value: sliderValue)
    }
    
    // Action from touchbar slider
    @IBAction func touchBarAllLampsSliderChanged(_ sender: NSSlider) {
        guard let sliderValue = self.touchBarAllLampsSlider?.integerValue else { return }
        self.lampValueChanged(value: sliderValue)
    }
    
    // Action from keyboard
    override func keyUp(with event: NSEvent) {
        guard let keyChars = event.characters else { return }
        
        // FIXME: Cheaply manipulates the UI slider...
        if keyChars.contains("-") {
            self.allLampsSlider?.integerValue -= 10
        } else if keyChars.contains("+") || keyChars.contains("=") {
            self.allLampsSlider?.integerValue += 10
        }
        
        self.allLampsSliderChanged(nil)
    }

}

private extension ViewController {
    
    // Trigger lamp value change
    func lampValueChanged(value lampValue: Int) {
        DaliConnector.setAllLamps(to: lampValue) {
            self.updateUI()
        }
    }
    
    // Update UI
    func updateUI() {
        DaliConnector.averageLampValue { averageLampValue in
            // UI Slider
            self.allLampsSlider?.integerValue = averageLampValue
            
            // UI Label
            let percentage = (Double(averageLampValue)/255.0 * 100.0).rounded()
            self.allLampsValueLabel?.stringValue = "\(percentage) %"
            
            // TouchBar Slider
            self.touchBarAllLampsSlider?.integerValue = averageLampValue
        }
    }
    
}


