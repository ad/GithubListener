//
//  main.swift
//  GitHubListener
//
//  Created by Daniel Apatin on 24.04.2018.
//  Copyright © 2018 Daniel Apatin. All rights reserved.
//

import Cocoa

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate

let ret = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
