import UIKit
import CoreData
import Foundation

class Scores: NSObject {
    
    // all score entries
    var collection: [Score] = []
    
    override init() {
        super.init()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Scores")
        
        do {
            let result = (try managedContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
            
            var score: Score
            for entity in result {
                score = Score(managedObject: entity)
                self.collection.append(score)
            }
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.sort()
    }
    
    // append an entry to collection
    func append(score: Score) -> Scores {
        self.collection.append(score)
        
        return self.sort()
    }

    // sort this collection
    func sort() -> Scores {
        self.collection.sortInPlace({
            (scoreA: Score, scoreB: Score) in
            
            if (scoreA.score == scoreB.score) {
                return scoreA.date.timeIntervalSince1970 < scoreB.date.timeIntervalSince1970
            }
            
            return scoreA.score > scoreB.score
        })
        
        return self
    }
}