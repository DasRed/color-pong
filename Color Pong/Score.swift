import UIKit
import CoreData
import Foundation

class Score: NSObject {
    
    //score value
    var score: Int {
        get {
            var score = self.managedObject.valueForKey("score")
            if (score == nil) {
                score = 0
                self.managedObject.setValue(score, forKey: "score")
            }
            
            return score as! Int
        }
        set(score) {
            self.managedObject.setValue(score, forKey: "score")
        }
    }
    
    // date of save
    var date: NSDate {
        get {
            var date = self.managedObject.valueForKey("date")
            if (date == nil) {
                date = NSDate()
                self.managedObject.setValue(date, forKey: "date")
            }
            
            return date as! NSDate
        }
        set(date) {
            self.managedObject.setValue(date, forKey: "date")
        }
    }
    
    // the managed object in DB
    var managedObject: NSManagedObject {
        get {
            if (self.managedObjectInternal == nil) {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                let entity =  NSEntityDescription.entityForName("Scores", inManagedObjectContext:managedContext)
                self.managedObjectInternal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            }
            
            return self.managedObjectInternal!
        }
        
        set(newManagedObject) {
            self.managedObjectInternal = newManagedObject
        }
    }
    
    // the internal reference to the managed object
    private var managedObjectInternal: NSManagedObject?
    
    // init with simple values
    init(score: Int, date: NSDate = NSDate()) {
        super.init()
        self.score = score
        self.date = date
    }
    
    // init with managed objects
    init(managedObject: NSManagedObject) {
        super.init()
        self.managedObject = managedObject
    }
    
    // saves this
    func save() -> Score {
        do {
            try self.managedObject.managedObjectContext!.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return self
    }
}