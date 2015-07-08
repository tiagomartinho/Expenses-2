import RealmSwift

public class Balance {
    public static func total()->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            if expense.personIndex == 0 {
                total += expense.amount
            }
            else {
                total -= expense.amount
            }
        }
        return total
    }
}