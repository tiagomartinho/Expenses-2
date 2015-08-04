import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
    {
        overwrite(url)
        removeImportedFile(url)
        return true
    }
    
    private func overwrite(url: NSURL){        
        let defaultPath = Realm().path
        let defaultParentPath = defaultPath.stringByDeletingLastPathComponent
        
        if let path = url.path {
            NSFileManager.defaultManager().removeItemAtPath(defaultPath, error: nil)
            NSFileManager.defaultManager().copyItemAtPath(path, toPath: defaultPath, error: nil)
        }        
    }
    
    private func removeImportedFile(url: NSURL){
        let fileManager = NSFileManager()
        if let path = url.path {
            fileManager.removeItemAtPath(path, error: nil)
        }
    }
}