import RealmSwift

public class Balance {
    public static func summary()->String{
        let total = self.total()
        
        if total == 0 {
            return "zero_balance".localized
        }
        
        let person1Name = defaults.objectForKey(kUD_Person1) as? String ?? "1"
        let person2Name = defaults.objectForKey(kUD_Person2) as? String ?? "2"
        
        let personInCredit = total > 0 ? person1Name : person2Name
        let personInDebt = total < 0 ? person1Name : person2Name
        
        return personInDebt + " " + "owes".localized + " " + personInCredit + " " + total.currency
    }
    
    public static func total()->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            total += expense.amount * multiplier(expense.paidBy,To:expense.paidTo)
        }
        return total
    }
    
    private static func multiplier(paidBy:Int,To paidTo:Int)->Double{
        return paidBy == paidTo ? 0.0 : sign(paidBy) / divider(paidTo)
    }
    
    private static func sign(paidBy:Int)->Double{
        return paidBy == 0 ? 1.0 : -1.0
    }
    
    private static func divider(paidTo:Int)->Double{
        return paidTo == 2 ? 2.0 : 1.0
    }
}