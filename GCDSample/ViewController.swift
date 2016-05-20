//
//  ViewController.swift
//  GCDSample
//
//  Created by Charles HARROCH on 20/05/2016.
//  Copyright © 2016 Charles HARROCH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webview : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // usage()
        self.group()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func creation() {
        
        // Main queue
        let _ = dispatch_get_main_queue()
        
        // Global queue: HIGH, DEFAULT ou LOW
        let _ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        // Custom queue: SERIAL ou CONCURRENT
        let _ = dispatch_queue_create("com.loyaltytechnology.queue", DISPATCH_QUEUE_SERIAL)
        
    }
    
    func usage() {
        
        let lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        print("before")
        
        dispatch_async(lowQueue) {
            print("inside first block")
            let html = self.getRemoteHTML(url : "http://google.fr")
            
            dispatch_async(dispatch_get_main_queue()) {
                print("inside second block")
                
                // Always use UIKit components in the main thread
                if let htmlString = html {
                    self.webview.loadHTMLString(htmlString, baseURL: nil)
                }
                print("finished!")
            }
        }
        print("after")
    }
    
    func group() {
        
        // Concurent Queue
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        
        // Serial Queue
        //let queue = dispatch_get_main_queue()
        
        let group = dispatch_group_create()
        
        for count in 0 ..< 1000 {
            dispatch_group_enter(group)
            dispatch_async(queue) {
                // Long job process
                print(count);
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, queue) {
            print("All jobs done!")
        }
    }
    
    func after() {
        let twoSeconds = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC))
        let queue      = dispatch_get_main_queue()
        
        print("before")
        dispatch_after(twoSeconds, queue) {
            print("2 seconds after")
        }
        print("after")
    }
}

extension ViewController {
    
    func getRemoteHTML(url urlString : String) -> String? {
        
        guard let myURL = NSURL(string: urlString) else {
            print("Error: \(urlString) doesn't seem to be a valid URL")
            return nil
        }
        
        do {
            let HTMLString = try String(contentsOfURL: myURL, encoding: NSASCIIStringEncoding)
            return "\(HTMLString)"
        } catch let error as NSError {
            print("Error: \(error)")
            return nil
        }
    }
}

