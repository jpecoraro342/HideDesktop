//
//  HideDesktopApp.swift
//  HideDesktop
//
//  Created by Joseph Pecoraro on 8/25/22.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    let finderDefaults = UserDefaults(suiteName: "com.apple.finder")
    var isVisible = true

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        updateIsVisible()
        updateStatusIcon()
        updateMenu()
    }
    
    func updateStatusIcon() {
        let imageName = isVisible ? "eye" : "eye.slash"
        statusItem.button?.image = NSImage(systemSymbolName: imageName, accessibilityDescription: "Toggle Desktop Icons")
    }

    func updateMenu() {
        let menu = NSMenu()
        
        let title = isVisible ? "Hide Desktop Icons" : "Show Desktop Icons"

        let toggleMenuItem = NSMenuItem(title: title, action: #selector(toggleDesktopIcons), keyEquivalent: "")
        
        menu.addItem(toggleMenuItem)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "Q"))

        statusItem.menu = menu
    }
    
    func updateIsVisible() {
        isVisible = finderDefaults?.bool(forKey: "CreateDesktop") ?? true
    }
    
    func restartFinder() {
        let shouldKeepWindowsOpen = finderDefaults?.bool(forKey: "NSQuitAlwaysKeepsWindows") ?? true
        
        // override preference for keeping windows open
        finderDefaults?.set(true, forKey: "NSQuitAlwaysKeepsWindows")
        
//        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder")
//        if apps.count > 0 {
//            let finder = apps[0]
//            finder.terminate()
//        }
        
        let killFinderProcess = Process();
        killFinderProcess.launchPath = "/usr/bin/killall"
        killFinderProcess.arguments = ["Finder"]
        killFinderProcess.launch()
        killFinderProcess.waitUntilExit()
        
        // restore user preference setting for keeping windows open
        finderDefaults?.set(shouldKeepWindowsOpen, forKey: "NSQuitAlwaysKeepsWindows")
    }

    @objc func toggleDesktopIcons() {
        finderDefaults?.set(!isVisible, forKey: "CreateDesktop")
        restartFinder()
        updateIsVisible()
        updateStatusIcon()
        updateMenu()
    }
}
