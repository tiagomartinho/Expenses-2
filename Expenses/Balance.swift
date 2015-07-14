import RealmSwift

public class Balance {
    public static func summary()->String{
        let person1Name = defaults.objectForKey(kUD_Person1) as? String ?? "1"
        let person2Name = defaults.objectForKey(kUD_Person2) as? String ?? "2"
        let total = self.total()
        if total > 0 {
            return person2Name + " " + "owes".localized + " " + person1Name + " " + absoluteTotalFormatted()
        }
        if total < 0 {
            return person1Name + " " + "owes".localized + " " + person2Name + " " + absoluteTotalFormatted()
        }
        return "zero_balance".localized
    }
    
    public static func absoluteTotalFormatted()->String{
        return total().currency
    }
    
    public static func total()->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            total += expense.amount * sign(expense.paidBy)
        }
        return total / 2
    }
    
    private static func sign(paidBy:Int)->Double{
        return paidBy == 0 ? 1.0 : -1.0
    }
}