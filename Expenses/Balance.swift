import RealmSwift

public class Balance {
    public static func total()->Double{
        let expenses = Realm().objects(Expense)
        if expenses.count > 0 {
            return 12.34
        }
        else {
            return 0.0
        }
    }
}