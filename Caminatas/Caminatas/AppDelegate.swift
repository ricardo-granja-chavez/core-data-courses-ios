//
//  AppDelegate.swift
//  Caminatas
//
//  Created by Ricardo Granja Chávez on 17/05/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "Caminatas")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let navController = self.window?.rootViewController as? UINavigationController,
              let viewController = navController.topViewController as? ViewController else { return true }
        
        viewController.managedContext = self.coreDataStack.managedContext
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.coreDataStack.saveContext()
    }
}

