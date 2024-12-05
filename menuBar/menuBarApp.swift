//
//  menuBarApp.swift
//  menuBar
//
//  Created by Quinton Pham on 12/4/24.
//

import SwiftUI
import AppKit

@main
struct MenuCounterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var menu: NSMenu!
    private var counter: Int = 0
    private var isLongLength: Bool = true
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: 40)
        
        if let button = statusItem.button {
            button.title = "\(counter)"
            
            // Create menu
            let menu = NSMenu()
            menu.delegate = self  // Set the delegate
            
            let resetItem = NSMenuItem(title: "Reset Counter",
                                     action: #selector(resetCounter),
                                     keyEquivalent: "r")
            resetItem.target = self
            menu.addItem(resetItem)
            
            let toggleLengthItem = NSMenuItem(title: "Toggle Length",
                                            action: #selector(toggleLength),
                                            keyEquivalent: "t")
            toggleLengthItem.target = self
            menu.addItem(toggleLengthItem)
            
            let incrementItem = NSMenuItem(title: "Increment Counter",
                                     action: #selector(increment),
                                     keyEquivalent: "j")
            incrementItem.target = self
            menu.addItem(incrementItem)
            
            menu.addItem(NSMenuItem.separator())
            
            let quitItem = NSMenuItem(title: "Quit",
                                    action: #selector(NSApplication.terminate(_:)),
                                    keyEquivalent: "q")
            menu.addItem(quitItem)
            
            // Store menu for later use
            self.menu = menu
            
            // Set up click handling
            button.target = self
            button.action = #selector(handleClick)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    @objc private func handleClick() {
        if let event = NSApp.currentEvent {
            switch event.type {
            case .rightMouseUp:
                statusItem.menu = menu
                statusItem.button?.performClick(nil)
            case .leftMouseUp:
                statusItem.menu = nil
                increment()
            default:
                break
            }
        }
    }
    
    @objc private func resetCounter() {
        counter = 0
        if let button = statusItem.button {
            button.title = "\(counter)"
        }
    }
    
    @objc private func toggleLength() {
        isLongLength.toggle()
        let newLength: CGFloat = isLongLength ? 40 : 15
        statusItem.length = newLength
    }
    
    @objc private func increment() {
        counter += 1
        updateTitle()
    }
    
    private func updateTitle() {
        statusItem.button?.title = "\(counter)"
    }
    
    // NSMenuDelegate method
    func menuDidClose(_ menu: NSMenu) {
        statusItem.menu = nil
    }
}
