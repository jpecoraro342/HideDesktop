//
//  main.swift
//  HideDesktop
//
//  Created by Joseph Pecoraro on 8/25/22.
//

import AppKit
import SwiftUI

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
