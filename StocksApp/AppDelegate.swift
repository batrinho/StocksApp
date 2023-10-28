//
//  AppDelegate.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit
import CoreData

extension UIApplication.State {
    var stringValue: String {
        switch self {
        case .active:
            "active"
        case .inactive:
            "inactive"
        case .background:
            "background"
        @unknown default:
            fatalError()
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var state: String?
    
    //    /Users/batyrtolkynbayev/Desktop/the folder/iOS Development/Adlet Abi Tasks/StocksApp
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = StocksViewController()
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        print("Application moved from \(state ?? "Not Running") to \(UIApplication.State.inactive.stringValue): \(#function)")
        state = UIApplication.State.inactive.stringValue
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Application moved from \(state ?? "Not Running") to \(UIApplication.State.inactive.stringValue): \(#function)")
        state = UIApplication.State.inactive.stringValue
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application moved from \(state ?? "") to \(UIApplication.State.active.stringValue): \(#function)")
        state = UIApplication.State.active.stringValue
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Application moved from \(state ?? "") to \(UIApplication.State.inactive.stringValue): \(#function)")
        state = UIApplication.State.inactive.stringValue
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application moved from \(state ?? "") to \(UIApplication.State.background.stringValue): \(#function)")
        state = UIApplication.State.background.stringValue
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Application moved from \(state ?? "") to Not Running: \(#function)")
        state = "Not Running"
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application moved from \(state ?? "") to \(UIApplication.State.inactive.stringValue): \(#function)")
        state = UIApplication.State.inactive.stringValue
    }

    // MARK: UISceneSession Lifecycle
    
    // MARK: - Core Data Saving support
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
