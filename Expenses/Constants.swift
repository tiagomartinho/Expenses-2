import Foundation

struct k {
    // User Defaults
    static let Defaults = NSUserDefaults.standardUserDefaults()
    static let UD_Person1 = "kUD_Person1"
    static let UD_Person2 = "kUD_Person2"
    static let UD_IdentityToken = "com.apple.MyAppName.UbiquityIdentityToken"
    static var Person1Name:String { return Defaults.objectForKey(UD_Person1) as? String ?? "default_person_1_name".localized }
    static var Person2Name:String { return Defaults.objectForKey(UD_Person2) as? String ?? "default_person_2_name".localized }
    
    // Cell Identifiers
    static let ExpenseCell = "ExpenseCell"
}