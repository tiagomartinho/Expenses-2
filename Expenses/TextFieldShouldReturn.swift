import UIKit

class TextFieldShouldReturn: NSObject, UITextFieldDelegate {
    
    func addTextField(textField:UITextField){
        textField.delegate=self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}