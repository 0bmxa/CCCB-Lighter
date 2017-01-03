//
//  WindowController.swift
//  CCCB Lighter
//
//  Created by mxa on 03.01.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
//        self.touchBar?.displayMode
        
    }

    
    /*
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = NSTouchBarCustomizationIdentifier(rawValue: "")
        return touchBar
    }
    */
}


@available(OSX 10.12.2, *)
extension WindowController: NSTouchBarDelegate {
    
}

