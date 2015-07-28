import RealmSwift

public class Balance {
    
    static let IN_COMMON_INDEX = 2
    
    public static var summaries:[String] {
        return [summary(),summaryPaidBy(0),summaryPaidBy(1),summarySpentBy(0),summarySpentBy(1)]
    }
    
    private static func summarySpentBy(personIndex:Int)->String{
        let total = self.totalSpentBy(personIndex)
        
        let personName = personIndex == 0 ? k.Person1Name : k.Person2Name
        
        return personName + " " + "spent".localized + " " + total.currency
    }
    
    private static func summaryPaidBy(personIndex:Int)->String{
        let total = self.totalPaidBy(personIndex)
        
        let personName = personIndex == 0 ? k.Person1Name : k.Person2Name
        
        return personName + " " + "paid".localized + " " + total.currency
    }
    
    private static func summary()->String{
        let total = self.total()
        
        if total == 0 {
            return "zero_balance".localized
        }
        
        let personInCredit = total > 0 ? k.Person1Name : k.Person2Name
        let personInDebt = total < 0 ? k.Person1Name : k.Person2Name
        
        return personInDebt + " " + "owes".localized + " " + personInCredit + " " + total.currency
    }
    
    public static func totalSpentBy(personIndex:Int)->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            if expense.paidTo == personIndex {
                total += expense.amount
            }
            if expense.paidTo == IN_COMMON_INDEX {
                total += (expense.amount/2)
            }
        }
        return total
    }
    
    public static func totalPaidBy(personIndex:Int)->Double{
        var total = 0.0
        for expense in Realm().objects(Expense) {
            if expense.paidBy == personIndex {
                total += expense.amount
            }
        }
        return total
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
        return paidTo == IN_COMMON_INDEX ? 2.0 : 1.0
    }
}