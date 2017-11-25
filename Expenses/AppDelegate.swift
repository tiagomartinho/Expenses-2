import UIKit
import RealmSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    fileprivate var url:URL?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics()])
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    {
        self.url = url
        showAlertToMergeExpenses()
        return true
    }
    
    fileprivate func showAlertToMergeExpenses(){
        let alert = UIAlertController(title: "attention".localized, message: "merge_warning".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action:UIAlertAction!) -> Void in
            self.removeImportedFile()
        }))
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action:UIAlertAction!) -> Void in
            self.overwrite()
            self.removeImportedFile()
            Answers.logCustomEvent(withName: "Expenses Imported", customAttributes:  nil)
        }))
        if let rootVC = self.window?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func overwrite(){
        let defaultPath = Realm().path
        let importedPath = defaultPath + ".imported"
        
        if let path = url?.path {
            let fileManager = FileManager.default
            fileManager.removeItemAtPath(importedPath, error: nil)
            fileManager.copyItemAtPath(path, toPath: importedPath, error: nil)
            let importedRealm = Realm(path: importedPath)
            let importedExpenses = importedRealm.objects(Expense)
            RealmUtilities.updateEntries(importedExpenses)
        }
    }
    
    fileprivate func removeImportedFile(){
        let fileManager = FileManager()
        if let path = url?.path {
            fileManager.removeItemAtPath(path, error: nil)
        }
    }
}
