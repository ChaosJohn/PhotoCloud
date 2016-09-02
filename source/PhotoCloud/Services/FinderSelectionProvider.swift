//
//  FinderSelectionProvider.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation
import ScriptingBridge

open class FinderSelectionProvider {
    
    open static let instance = FinderSelectionProvider()
    
    fileprivate init(){}
    
    open func getSelectedFolders() -> [URL] {
        guard let finder = SBApplication(bundleIdentifier: "com.apple.finder") as? FinderApplication,
            let result = finder.selection else {
                NSLog("No items selected")
                return []
        }
        guard let selection = result.get() else {
            NSLog("No items selected")
            return []
        }
        
        let items = (selection as AnyObject).array(byApplying: #selector(getter: NSTextCheckingResult.url))
        let fm = FileManager.default
        return items.filter {
            item -> Bool in
            let url = URL(string: item as! String)!
            return fm.checkIfDirectoryExists(url.path)
            }.map { return URL(string: $0 as! String)!}
    }
    
    open func getSelectedFiles() -> [URL] {
        guard let finder = SBApplication(bundleIdentifier: "com.apple.finder") as? FinderApplication,
            let result = finder.selection else {
                NSLog("No items selected")
                return []
        }
        guard let selection = result.get() else {
            NSLog("No items selected")
            return []
        }
        
        let items = (selection as AnyObject).array(byApplying: #selector(getter: NSTextCheckingResult.url))
        let fm = FileManager.default
        return items.filter {
            item -> Bool in
            let url = URL(string: item as! String)!
            return fm.checkIfFileExists(url.path)
            }.map { return URL(string: $0 as! String)!}
    }
    
    
    open func getSelectedFAcceptableFiles()->[URL] {
        return getSelectedFiles()
    }
    

}
