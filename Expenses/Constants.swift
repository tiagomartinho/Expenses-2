import Foundation

struct k {
    // User Defaults
    static let Defaults = NSUserDefaults.standardUserDefaults()
    // Persons Names
    static let UD_Person1 = "UD_Person1"
    static let UD_Person2 = "UD_Person2"
    static var Person1Name:String { return Defaults.objectForKey(UD_Person1) as? String ?? "default_person_1_name".localized }
    static var Person2Name:String { return Defaults.objectForKey(UD_Person2) as? String ?? "default_person_2_name".localized }
    
    // Cell Identifiers
    static let ExpenseCell = "ExpenseCell"
}