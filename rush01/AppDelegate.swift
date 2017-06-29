//
//  AppDelegate.swift
//  day05
//
//  Created by Cristian Cosneanu on 4/26/17.
//  Copyright © 2017 Cristian Cosneanu. All rights reserved.
//

import UIKit
import CoreLocation


struct Pin {
    var name: String
    var title: String
    let coordinate_x: Double
    let coordinate_y: Double
    
    init(name: String, title: String, x: Double, y: Double) {
        self.name = name
        self.title = title
        self.coordinate_x = x
        self.coordinate_y = y
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var boo = false
    static var notDrawed = true
    static var selectedIndex:Int = 0
    static var FirstLocation:CLLocationCoordinate2D? = nil
    static var SecondLocation:CLLocationCoordinate2D? = nil
    
    static var pins: [Pin] = [
//        Pin(name:"Camin",title:"Strada Vasile Cheltuială, Chișinău, Moldova",x:47.009948,y:28.816538),
//        Pin(name:"Parc",title:"Strada Valea Trandafirilor 16, Chișinău, Moldova",x:47.002032 ,y:28.851814),
//        Pin(name:"Academy+",title:"Academy+Moldova",x: 47.041001,y: 28.818748)
    ]

    static var switches: [UISwitch] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

