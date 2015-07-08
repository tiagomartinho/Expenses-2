import UIKit

class ExpensesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var person:String? {
        didSet {
            personLabel.text = person
        }
    }
    
    var amount:String? {
        didSet {
            amountLabel.text = amount
        }
    }
    
    var category:String? {
        didSet {
            categoryLabel.text = category
        }
    }
    
    var date:String? {
        didSet {
            dateLabel.text = date
        }
    }
}