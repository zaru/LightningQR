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
class AppDelegate: NSObject, NSApplicationDelegate, Validator, NSUserNotificationCenterDelegate {

    var statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var changeCount: Int = 0
    let MyNotification = "MyNotification"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AppDelegate.loadQrcodePopover(notification:)),
                                               name: NSNotification.Name(rawValue: MyNotification),
                                               object: nil)
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusImage")
            button.action = #selector(AppDelegate.togglePopover(sender:))
        }
        
        if let keyCombo = KeyCombo(keyCode: 11, carbonModifiers: 4352) {
            let hotKey = HotKey(identifier: "CommandControlB", keyCombo: keyCombo, target: self, action: #selector(hoge))
            hotKey.register() // or HotKeyCenter.shared.register(with: hotKey)
        }
        
        popover.behavior = .transient
        popover.contentViewController = QrcodeViewController(nibName: "QrcodeViewController", bundle: nil)
        
        beginObservingPasteboard()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func hoge() {
        print("hoge");
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
    
    func closePopover(sender: AnyObject?) {
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
        let str = pboard.string(forType: NSStringPboardType)!
        if (validateURL(urlString: str)) {
            print(str)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.MyNotification),
                                            object: nil,
                                            userInfo: ["url": str])
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

