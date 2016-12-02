//
//  ViewController.swift
//  LightningQR
//
//  Created by hiro on 2016/12/02.
//  Copyright © 2016年 zaru. All rights reserved.
//

import Cocoa
import CoreImage

class ViewController: NSViewController {
    
    var changeCount: Int = 0
    @IBOutlet weak var qrImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    


}

