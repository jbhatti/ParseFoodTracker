//
//  AppDelegate.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureParse()
        //createObj()
        return true
    }
    
    private func configureParse() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.jaisonbhatti.ParseDemo"
            $0.clientKey = "com.jaisonbhatti.ParseDemo"
            $0.server = "http://jbhatti-parsedemo.herokuapp.com/parse"
        }
        Parse.initialize(with: configuration)
        
    }
    
    private func createObj() {
    let testObj = PFObject(className: "testObj")
    testObj["foo"] = "bar"
    testObj.saveInBackground()
    }
    
    
}

