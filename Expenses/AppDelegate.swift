import UIKit
import RealmSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var url:NSURL?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
    {
        self.url = url
        showAlertToRelaceExpenses()
        return true
    }
    
    private func showAlertToRelaceExpenses(){
        var alert = UIAlertController(title: "Attention", message: "This will merge the imported expenses with your expenses", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction!) -> Void in
            self.removeImportedFile()
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            self.overwrite()
            self.removeImportedFile()
        }))
        if let rootVC = self.window?.rootViewController {
            rootVC.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func overwrite(){
        let defaultPath = Realm().path
        let importedPath = defaultPath + ".imported"
        
        if let path = url?.path {
            let fileManager = NSFileManager.defaultManager()
            fileManager.removeItemAtPath(importedPath, error: nil)
            fileManager.copyItemAtPath(path, toPath: importedPath, error: nil)
            let importedRealm = Realm(path: importedPath)
            let importedExpenses = importedRealm.objects(Expense)
            RealmUtilities.updateEntries(importedExpenses)
        }        
    }
    
    private func removeImportedFile(){
        let fileManager = NSFileManager()
        if let path = url?.path {
            fileManager.removeItemAtPath(path, error: nil)
        }
    }
}