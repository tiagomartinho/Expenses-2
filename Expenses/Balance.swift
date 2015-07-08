import RealmSwift

public class Balance {
    public static func total()->Double{
        let expenses = Realm().objects(Expense)
        return expenses.first?.amount ?? 0.0
    }
}