import RealmSwift

public class Balance {
    public static func total()->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            let sign = expense.personIndex == 0 ? 1.0 : -1.0
            total += (expense.amount * sign)
        }
        return total
    }
}