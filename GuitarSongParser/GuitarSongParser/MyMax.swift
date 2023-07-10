
import Foundation
import os.log

class MyMax: NSObject, NSCoding{
    var a:String
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("mymax")
    struct PropertyKey {
        static let a = "a"
    }

    init(a:String){
        self.a = a
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(a, forKey: PropertyKey.a)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let a = aDecoder.decodeObject(forKey: PropertyKey.a) as? String else {
            os_log("Unable to decode the max.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(a:a) //, photo: photo, rating: rating
        
    }
    

}
