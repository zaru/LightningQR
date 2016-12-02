//
//  Qrcode.swift
//  LightningQR
//
//  Created by hiro on 2016/12/03.
//  Copyright © 2016年 zaru. All rights reserved.
//

import Cocoa
import CoreImage

class Qrcode {
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
