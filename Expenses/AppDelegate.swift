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
            deleteRealmFilesAtPath(defaultPath)
            let fileManager = NSFileManager.defaultManager()
            fileManager.copyItemAtPath(path, toPath: defaultPath, error: nil)
        }
        
        Realm().refresh()
    }
    
    private func deleteRealmFilesAtPath(path: String) {
        let fileManager = NSFileManager.defaultManager()
        fileManager.removeItemAtPath(path, error: nil)
        let lockPath = path + ".lock"
        fileManager.removeItemAtPath(lockPath, error: nil)
    }
    
    private func removeImportedFile(url: NSURL){
        let fileManager = NSFileManager()
        if let path = url.path {
            fileManager.removeItemAtPath(path, error: nil)
        }
    }
}