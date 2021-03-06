//
//  AppDelegate.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/04/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import XCGLogger

let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if ProcessInfo().environment["UITesting"] == nil {
            configureLog()
            Fabric.with([Crashlytics.self])
        }

        let productApi = ProductService()
        let searchTVC = findSearchTVCFromRootController()
        searchTVC?.productApi = productApi

        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "scan" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateInitialViewController()
            window?.rootViewController = rootVC

            let productApi = ProductService()
            let searchTVC = findSearchTVCFromRootController()
            searchTVC?.productApi = productApi

            let scanVC = ScannerViewController(productApi: productApi)
            searchTVC?.navigationController?.pushViewController(scanVC, animated: false)
        }
    }

    fileprivate func configureLog() {
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        log.add(destination: systemDestination)
        log.logAppDetails()

    }

    fileprivate func findSearchTVCFromRootController() -> SearchTableViewController? {
        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let navController = child as? UINavigationController, let vc = navController.topViewController as? SearchTableViewController {
                    return vc
                }
            }
        }

        return nil
    }
}
