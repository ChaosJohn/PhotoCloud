//
//  HistoryWindowController.swift
//  PhotoCloud
//
//  Created by liupeng on 19/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa
import RealmSwift
class HistoryWindowController: NSWindowController {
    @IBOutlet var tableview: NSTableView!

    @IBOutlet var scrollview: NSScrollView!
    fileprivate var uploadHistory = NSMutableArray()
      @IBOutlet var view: NSView!
    convenience init() {
        self.init(windowNibName: "HistoryWindowController")
    }
    override func windowDidLoad() {
        super.windowDidLoad()
       
        
        tableview.selectionHighlightStyle = .regular
        tableview.gridStyleMask = NSTableViewGridLineStyle()
        tableview.register(NSNib(nibNamed: "HistoryTableCell", bundle: nil), forIdentifier: "HistoryTableCell")
        
       
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSWindowWillClose, object: self.window, queue: nil) { notification in
            NSApp.stopModal()
        }
        
        if let window = window {
            window.title = "上传记录"
//            window.styleMask = NSTitledWindowMask | NSClosableWindowMask | NSFullSizeContentViewWindowMask | NSResizableWindowMask
        }

    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        uploadHistory.removeAllObjects()
        let allHistorys = PhotoCloudStoreProvider.SharedPhotoCloudStore().photoCloudItemList
        for item in allHistorys {
            uploadHistory.add(item)
        }
        tableview.reloadData()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HistoryWindowController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.uploadHistory.count
    }
    
}

extension HistoryWindowController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "HistoryTableCell", owner: tableView) as? HistoryTableCell
        let item = self.uploadHistory[row] as? PhotoCloudItemModel
        cell?.tx_fileName.stringValue = item?.fileName ?? ""
        cell?.tx_downloadUrl.stringValue = item?.downloadUrl ?? ""
        cell?.imageview?.setImageURL(item?.downloadUrl ?? "")
        cell?.wantsLayer = true
        cell?.layer?.backgroundColor = NSColor.white.cgColor
        return cell
    }
}
