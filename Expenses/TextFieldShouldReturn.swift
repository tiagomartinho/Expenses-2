import UIKit

class TextFieldShouldReturn: NSObject, UITextFieldDelegate {
    
    func addTextField(_ textField:UITextField){
        textField.delegate=self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
