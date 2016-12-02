//
//  AppDelegate.swift
//  LightningQR
//
//  Created by hiro on 2016/12/02.
//  Copyright © 2016年 zaru. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, Validator {

    var statusItem = NSStatusBar.system().statusItem(withLength: -2)
    var changeCount: Int = 0

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
        }
        
        beginObservingPasteboard()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func beginObservingPasteboard() {
        self.changeCount = NSPasteboard.general().changeCount
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(observePasteboard),
                             userInfo: nil,
                             repeats: true)
    }
    
    func observePasteboard() {
        let pboard = NSPasteboard.general()
        if (pboard.changeCount > self.changeCount) {
            pasteboardChanged(pboard: pboard)
        }
        self.changeCount = pboard.changeCount
    }
    
    func pasteboardChanged(pboard:NSPasteboard) {
        let str = pboard.string(forType: NSStringPboardType)
        print(str)
        print(validateURL(urlString: str!))
        
    }


}


protocol Validator {
    func validateURL(urlString: String) -> Bool
}

extension Validator {
    func validateURL(urlString: String) -> Bool {
        var result = false
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        guard let detect = detector else {
            return result
        }
        let matches = detect.matches(in: urlString, options: .reportCompletion, range: NSMakeRange(0, urlString.characters.count))
        for match in matches {
            if let url = match.url {
                result = true
            }
        }
        return result
    }
}

