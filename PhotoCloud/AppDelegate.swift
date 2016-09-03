//
//  AppDelegate.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    
    lazy var preferences: MASPreferencesWindowController = {
        let preferences = MASPreferencesWindowController(viewControllers: [
            GeneralPreferencesViewController(nibName: "GeneralPreferencesViewController", bundle: nil)!,
            UserPreferencesViewController(nibName: "UserPreferencesViewController", bundle: nil)!,
            ShortcutPreferencesViewController(nibName: "ShortcutPreferencesViewController", bundle: nil)!], title: NSLocalizedString("偏好设置", comment: ""))
        return preferences!
    }()
    
    lazy var historyWindowController: HistoryWindowController = {
        return HistoryWindowController()
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.configStatusBarMenu()
        self.registerHotKey()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.onEndCapture(_:)), name: NSNotification.Name(rawValue: kNotifyCaptureEnd), object: nil)
        //init qnConfig
        guard let _ = Preferences.SharedPreferences().currentQNAccountConfig else {
            // need set pref
            showPreferencesWindowAction(nil)
            return
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
         NotificationCenter.default.removeObserver(self)
        self.unRegisterHotKey()
    }
    
    @IBAction func showPreferencesWindowAction(_ sender: AnyObject?) {
        preferences.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    func registerHotKey() {
        //https://gist.github.com/liufsd/69304e0d4511f607d824
        //Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
        //Command  + 5
        //Command + u
        HotKeyMonitor.sharedInstance().hotKeyMonitorDelegate = self
    }
    
    func unRegisterHotKey() {
        HotKeyMonitor.sharedInstance().hotKeyMonitorDelegate = nil
    }
    
    func onEndCapture(_ notif: Notification) {
        if let image =  (notif as NSNotification).userInfo?["image"] as? NSImage {
            let path: String = PhotoCloudStrings.FileConstants.buildTempImagePath()
            image.savePNG(path)
            if FileManager.default.checkIfFileExists(path) {
                QiniuProvider.instance.uploadFile(URL(string: path)!)
            }
        }
    }
}

// MARK: ConfigStatusBarMenus
extension AppDelegate: MenuBarControllerDelegate {
    func configStatusBarMenu(){
        let statusMenu = NSMenu(title:"PhotoCloud")
        statusMenu.addItem(NSMenuItem(title:"偏好设置",action:#selector(AppDelegate.showPreferencesWindowAction(_:)),keyEquivalent:""))
        statusMenu.addItem(NSMenuItem(title:"上传记录",action:#selector(AppDelegate.historyItemClick(_:)),keyEquivalent:""))
        statusMenu.addItem(NSMenuItem(title:"退出应用",action:#selector(AppDelegate.quitItemClicked(_:)),keyEquivalent:""))
        
        //create the status item
        let statusItem :NSStatusItem = NSStatusBar.system().statusItem(withLength: CGFloat(NSSquareStatusItemLength))
        statusItem.highlightMode = true
        let image = NSImage(named: "menubar")
        image?.isTemplate = true
      
        menuBarController = MenuBarController(image: image, menu: statusMenu)
        menuBarController?.delegate = self
        menuBarController?.showStatusItem()
    }
    
    func menuBarControllerStatusChanged(_ active: Bool) {
        
        
    }
    
    func quitItemClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    func historyItemClick(_ sender: AnyObject) {
        self.historyWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension AppDelegate: HotKeyMonitorDelegate {
    
    func onHotKeyMonitorUpload() {
        let urls = FinderSelectionProvider.instance.getSelectedFAcceptableFiles()
        for url in urls {
            QiniuProvider.instance.uploadFile(url)
        }
    }
    
    func onHotKeyMonitorCapture() {
        SnipManager.sharedInstance().startCapture()
    }
}

