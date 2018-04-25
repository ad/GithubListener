//
//  SignInViewController.swift
//  GitHubListener
//
//  Created by Daniel Apatin on 25.04.2018.
//  Copyright © 2018 Daniel Apatin. All rights reserved.
//

import Cocoa
import WebKit

class NiblessWindowController: NSWindowController, WKNavigationDelegate {
    
    let clientId = "88a135874dd3d8db2cc5"
    let clientSecret = "cf3732358810336da79359b1d90810474034765e"
    
    var webView: WKWebView?
    
    required init(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    init() {
        super.init(window: nil)
        let rect = NSMakeRect(0, 0, 400, 400)
        let window = NSWindow(contentRect:rect, styleMask: .titled, backing:.buffered, defer:false)
        let view = NSView()
        window.center()
        window.contentView = view
        window.title = "App"
        self.window = window
        
        self.viewDidLoad()
    }
    
    func viewDidLoad() {
        webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))
        
//        removeCookies()
        
        webView?.navigationDelegate = self

        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)"
        if let url = NSURL(string: urlString) {
            let req = NSURLRequest(url: url as URL)
            webView?.load((req as URLRequest?)!)
        }
        self.window?.contentView?.addSubview(webView!)
    }
    
    func removeCookies() {
        let cookie = HTTPCookie.self
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) { // -> Bool

        if let url = navigationAction.request.url, url.host == "gl.apatin.ru" {
            if let code = url.query?.components(separatedBy: "code=").last {
                let urlString = "https://github.com/login/oauth/access_token"
                if let tokenUrl = NSURL(string: urlString) {
                    let req = NSMutableURLRequest(url: tokenUrl as URL)
                    req.httpMethod = "POST"
                    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    req.addValue("application/json", forHTTPHeaderField: "Accept")
                    let params = [
                        "client_id" : clientId,
                        "client_secret" : clientSecret,
                        "code" : code
                    ]
                    req.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                    let task = URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
                        if let data = data {
                            do {
                                if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    if let accessToken = content["access_token"] as? String {
                                        print("access_token", accessToken)
                                        self.window?.close()
                                    }
                                }
                            } catch {}
                        }
                    }
                    task.resume()
                }
            }
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
