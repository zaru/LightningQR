//
//  AppDelegate.swift
//  LightningQR
//
//  Created by hiro on 2016/12/02.
//  Copyright © 2016年 zaru. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
        }
        
        if let keyCombo = KeyCombo(keyCode: 11, carbonModifiers: 4352) {
            let hotKey = HotKey(identifier: "CommandControlB", keyCombo: keyCombo, target: self, action: #selector(hoge))
            hotKey.register() // or HotKeyCenter.shared.register(with: hotKey)
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func hoge() {
        print("hoge");
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

