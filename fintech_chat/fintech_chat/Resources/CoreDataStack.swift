import Foundation
import CoreData

class CoreDataStack {
    
    private static var instance: CoreDataStack?
    
    static var shared: CoreDataStack {
        guard let instance = self.instance else {
            let newInstance = CoreDataStack()
            self.instance = newInstance
            return newInstance
        }
        return instance
    }
    
    private init() {}
    
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var databaseUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to read documents")
        }
        
        let documentUrl = documentsUrl.appendingPathComponent("Chats.sqlite")
        print(documentUrl)
        return documentUrl
    }()
    
    private let modelName = "Chats"
    private let modelExtension = "momd"
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: self.modelName, withExtension: self.modelExtension) else {fatalError("Unable to find Data Model")}
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else { fatalError("Unable to load Data Model")}
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.databaseUrl,
                                               options: nil)
        } catch {
            fatalError("Unable to load Persistent Store. \(error.localizedDescription)")
        }
        
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }
    
    // MARK: - Save Context
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        
        context.perform {
            block(context)
            if context.hasChanges {
                self.performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.perform {
            do {
                //print("is main thread: \(Thread.isMainThread)")
                try context.save()
                if let parent = context.parent {
                    self.performSave(in: parent)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Requests
    func getChannel(with id: String, in context: NSManagedObjectContext? = nil) -> ChannelDb? {
        do {
            let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
            
            let predicate = NSPredicate(format: "identifier == %@", id)
            request.predicate = predicate
            
            let contextForRequest = context ?? mainContext
            let channels = try contextForRequest.fetch(request)
            
            return channels.first
        } catch {
            Logger.app.logMessage("getChannel Error \(error.localizedDescription)", logLevel: .error)
            return nil
        }
    }
}

// MARK: - Core Data Logs
extension CoreDataStack {
    func printStatistic() {
        mainContext.perform {
            do {
                Logger.app.logMessage("Core Data Statistic", logLevel: .info)
                
                let countChannels = try self.mainContext.count(for: ChannelDb.fetchRequest())
                Logger.app.logMessage("📱: \(countChannels) channels", logLevel: .info)
                let countMessages = try self.mainContext.count(for: MessageDb.fetchRequest())
                Logger.app.logMessage("✉️: \(countMessages) messages", logLevel: .info)
                
//                let array = try self.mainContext.fetch(ChannelDb.fetchRequest()) as? [ChannelDb] ?? []
//                array.forEach {
//                    Logger.app.logMessage($0.statistic, logLevel: .info)
//                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: - Observers
extension CoreDataStack {
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            Logger.app.logMessage("Added objects: \(inserts.count)", logLevel: .info)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            Logger.app.logMessage("Updated objects: \(updates.count)", logLevel: .info)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            Logger.app.logMessage("Deleted objects: \(deletes.count)", logLevel: .info)
        }
    }
}
