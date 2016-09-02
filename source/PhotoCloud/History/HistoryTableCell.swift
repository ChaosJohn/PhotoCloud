//
//  HistoryTableCell.swift
//  PhotoCloud
//
//  Created by liupeng on 19/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa

class HistoryTableCell: NSTableCellView {
    @IBOutlet var tx_fileName: NSTextField!

    @IBOutlet var imageview: SKImageView!
    @IBOutlet var tx_downloadUrl: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func pressCopyAction(_ sender: AnyObject) {
        let pasteBoard = NSPasteboard.general()
        pasteBoard.declareTypes([NSStringPboardType], owner: nil)
        pasteBoard.setString(tx_downloadUrl.stringValue, forType: NSStringPboardType)
    }
}
