//
//  main.swift
//  GitHubListener
//
//  Created by Daniel Apatin on 24.04.2018.
//  Copyright © 2018 Daniel Apatin. All rights reserved.
//

import Cocoa
import WebKit

let app = NSApplication.shared
let delegate = AppDelegate(app: app)
app.delegate = delegate
NSApplication.shared.delegate = delegate

let ret = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

app.setActivationPolicy(.regular)
atexit_b { app.setActivationPolicy(.prohibited); return }
app.run()
