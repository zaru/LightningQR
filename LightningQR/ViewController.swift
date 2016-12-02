//
//  ViewController.swift
//  LightningQR
//
//  Created by hiro on 2016/12/02.
//  Copyright © 2016年 zaru. All rights reserved.
//

import Cocoa
import CoreImage

class ViewController: NSViewController, Validator {
    
    var changeCount: Int = 0
    @IBOutlet weak var qrImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginObservingPasteboard()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
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
        let str = pboard.string(forType: NSStringPboardType)
        if (validateURL(urlString: str!)) {
            qrImage.image = generateQR(url: str!)
        }
        
    }
    
    func generateQR (url:String) -> NSImage {
        let data = url.data(using: String.Encoding.utf8)
        
        let qr = CIFilter(name: "CIQRCodeGenerator",
                          withInputParameters: [
                            "inputMessage": data,
                            "inputCorrectionLevel": "M"])!
        
        
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = qr.outputImage!.applying(sizeTransform)
        let rep = NSCIImageRep.init(ciImage: qrImage)
        let nsimage = NSImage.init(size: rep.size)
        nsimage.addRepresentation(rep)
        return nsimage
    }


}

