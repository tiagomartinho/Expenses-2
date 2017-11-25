import RealmSwift

open class Balance {
    
    static let IN_COMMON_INDEX = 2
    
    open static var summaries:[String] {
        return [summary(),summaryPaidBy(0),summaryPaidBy(1),summarySpentBy(0),summarySpentBy(1)]
    }
    
    fileprivate static func summarySpentBy(_ personIndex:Int)->String{
        let total = self.totalSpentBy(personIndex)
        
        let personName = personIndex == 0 ? k.Person1Name : k.Person2Name
        
        return personName + " " + "spent".localized + " " + total.currency
    }
    
    fileprivate static func summaryPaidBy(_ personIndex:Int)->String{
        let total = self.totalPaidBy(personIndex)
        
        let personName = personIndex == 0 ? k.Person1Name : k.Person2Name
        
        return personName + " " + "paid".localized + " " + total.currency
    }
    
    fileprivate static func summary()->String{
        let total = self.total()
        
        if total == 0 {
            return "zero_balance".localized
        }
        
        let personInCredit = total > 0 ? k.Person1Name : k.Person2Name
        let personInDebt = total < 0 ? k.Person1Name : k.Person2Name
        
        return personInDebt + " " + "owes".localized + " " + personInCredit + " " + total.currency
    }
    
    open static func totalSpentBy(_ personIndex:Int)->Double{
        var total = 0.0
        for expense in try! Realm().objects(Expense.self) {
            if expense.paidTo == personIndex {
                total += expense.amount
            }
            if expense.paidTo == IN_COMMON_INDEX {
                total += (expense.amount/2)
            }
        }
        return total
    }
    
    open static func totalPaidBy(_ personIndex:Int)->Double{
        var total = 0.0
        for expense in try! Realm().objects(Expense.self) {
            if expense.paidBy == personIndex {
                total += expense.amount
            }
        }
        return total
    }
    
    open static func total()->Double{
        var total = 0.0
        for expense in try! Realm().objects(Expense.self) {
            total += expense.amount * multiplier(expense.paidBy,To:expense.paidTo)
        }
        return total
    }
    
    fileprivate static func multiplier(_ paidBy:Int,To paidTo:Int)->Double{
        return paidBy == paidTo ? 0.0 : sign(paidBy) / divider(paidTo)
    }
    
    fileprivate static func sign(_ paidBy:Int)->Double{
        return paidBy == 0 ? 1.0 : -1.0
    }
    
    fileprivate static func divider(_ paidTo:Int)->Double{
        return paidTo == IN_COMMON_INDEX ? 2.0 : 1.0
    }
}
