//
//  QrcodeViewController.swift
//  LightningQR
//
//  Created by hiro on 2016/12/03.
//  Copyright © 2016年 zaru. All rights reserved.
//

import Cocoa

class QrcodeViewController: NSViewController {

    @IBOutlet weak var imgQrcode: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        let ud = UserDefaults.standard
        let url:String = ud.object(forKey: "url") as! String!
        let qrcode = Qrcode().generateQR(url: url)
        imgQrcode.image = qrcode
    }
    
    @IBAction func terminate(_ sender: NSButton) {
        NSApp.terminate(self)
    }
    
    override func cancelOperation(_ sender: Any?) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.closePopover(sender: nil)
    }
}
