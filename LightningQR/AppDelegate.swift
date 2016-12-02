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
class AppDelegate: NSObject, NSApplicationDelegate, Validator {

    var statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var changeCount: Int = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
            button.action = #selector(AppDelegate.togglePopover(sender:))
        }
        
        if let keyCombo = KeyCombo(keyCode: 8, carbonModifiers: 4352) {
            let hotKey = HotKey(identifier: "CommandControlC", keyCombo: keyCombo, target: self, action: #selector(showPopover))
            hotKey.register() // or HotKeyCenter.shared.register(with: hotKey)
        }
        
        popover.behavior = .transient
        popover.contentViewController = QrcodeViewController(nibName: "QrcodeViewController", bundle: nil)
        
        beginObservingPasteboard()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            NSApplication.shared().activate(ignoringOtherApps: true)
        }
    }
    
    public func closePopover(sender: AnyObject?) {
        print("close")
        print(popover.isShown)
        popover.performClose(sender)
    }
    
    func loadQrcodePopover(notification: NSNotification)  {
        if let userInfo = notification.userInfo {
            let url = userInfo["url"]! as! String
            let ud = UserDefaults.standard
            ud.set(url, forKey: "url")
            showPopover(sender: nil)
        }
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
        let url = pboard.string(forType: NSStringPboardType)!
        if (validateURL(urlString: url)) {
            let ud = UserDefaults.standard
            ud.set(url, forKey: "url")
        }
        
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

