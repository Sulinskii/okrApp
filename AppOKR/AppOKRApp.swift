//
//  AppOKRApp.swift
//  AppOKR
//
//  Created by Artur Sulinski on 19/12/2021.
//

import SwiftUI
import Firebase
import CoreData
import FirebaseAnalytics

@main
struct AppOKRApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AuthViewModel()
            ContentView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, CoreDataStack.viewContext)
            
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Firebase.Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent("[CUSTOM]_App_started", parameters: ["Works":true])
        return true
    }
}

enum CoreDataStack {
    static var viewContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "BooksList")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("\(#file), \(#function), \(error!.localizedDescription)")
            }
        }
        
        return container.viewContext
    }()
    
    static func save() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    static func delete() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: BookObject.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
