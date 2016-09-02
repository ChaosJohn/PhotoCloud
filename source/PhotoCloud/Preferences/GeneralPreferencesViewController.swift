//
//  GeneralPreferencesViewController.swift
//  PhotoCloud
//
//  Created by liupeng on 22/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa
import ServiceManagement

class GeneralPreferencesViewController: NSViewController {

    @IBOutlet var tx_prefix: NSTextField!
    @IBOutlet var check_atlogin: NSButton!
    @IBOutlet var check_notify: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.updateCheckState(check_atlogin, isCheck: Preferences.SharedPreferences().isAtLogin)
        self.updateCheckState(check_notify, isCheck: Preferences.SharedPreferences().isNotifyEnable)
        UITools.disableTextFieldDefaultFocus(self.tx_prefix)
        self.tx_prefix.stringValue = Preferences.SharedPreferences().filePrefix
    }
    
    @IBAction func checkStateNotify(_ sender: NSButton) {
        Preferences.SharedPreferences().isNotifyEnable = sender.state != NSOffState
       
    }
    
    @IBAction func checkStateAtLogin(_ sender: NSButton) {
        //http://atjason.com/en/Cocoa/SwiftCocoa_Auto%20Launch%20at%20Login.html  未实现
        Preferences.SharedPreferences().isAtLogin = sender.state != NSOffState
        let appBundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let autoLaunch = (sender.state == NSOnState)
        if SMLoginItemSetEnabled(appBundleIdentifier as CFString, autoLaunch) {
            if autoLaunch {
                NSLog("Successfully add login item.")
            } else {
                NSLog("Successfully remove login item.")
            }
            
        } else {
            NSLog("Failed to add login item.")
        }
    }
    
    @IBAction func save(_ sender: AnyObject) {
        if self.tx_prefix.stringValue.isEmpty{
            return
        }
        Preferences.SharedPreferences().filePrefix = self.tx_prefix.stringValue
        UITools.removeTextFieldFocus(self.tx_prefix)
    }
    
    fileprivate func updateCheckState(_ sender:NSButton,isCheck:Bool) {
        if isCheck {
            sender.state = NSOnState
        } else {
            sender.state = NSOffState
        }
    }
}

// MARK: - MASPreferencesViewController
extension GeneralPreferencesViewController: MASPreferencesViewController {
    
    override var identifier: String? {
        get {
            return "general"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage! {
        return NSImage(named: NSImageNamePreferencesGeneral)
    }
    
    var toolbarItemLabel: String! {
        return "常规"
    }
}
