//
//  AppDelegate.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("AIzaSyAXv6MMlxuQiRTbAprCRdPsJ-0L4PH74Xg")
        return true
    }
}
