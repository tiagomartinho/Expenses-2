import RealmSwift

public class Balance {
    public static func total()->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            total += expense.amount
        }
        return total
    }
}