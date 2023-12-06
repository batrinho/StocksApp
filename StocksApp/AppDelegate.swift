//
//  AppDelegate.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    enum AppState {
        case notRunning
        case active
        case inactive
        case background
    }
    
    private var state: AppState = .notRunning {
        didSet {
            print("Application moved from \(oldValue) to \(state)")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let networkingService = NetworkingService()
        let coreDataDatabaseManager = CoreDataDatabaseManager()
        
        let stocksVCPresenter = StocksViewControllerPresenter(
            networkingService: networkingService,
            coreDataDatabaseManager: coreDataDatabaseManager
        )
        let stocksVC = StocksViewController(presenter: stocksVCPresenter)
        stocksVCPresenter.input = stocksVC
        
        let rootViewController = UINavigationController(rootViewController: stocksVC)
        
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        state = .inactive
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        state = .inactive
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        state = .active
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        state = .inactive
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        state = .background
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        state = .notRunning
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        state = .inactive
    }
    
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
