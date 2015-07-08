import RealmSwift

public class Balance {
    public static func total()->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            total += expense.amount * sign(expense.personIndex)
        }
        return total
    }
    
    private static func sign(personIndex:Int)->Double{
        return personIndex == 0 ? 1.0 : -1.0
    }
}