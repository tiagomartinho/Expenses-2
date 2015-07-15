import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        iCloudAvailability()
        return true
    }
    
    var listenningForUbiquityChanges = false
    func iCloudAvailability(){
        if !listenningForUbiquityChanges {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "iCloudAvailability:", name: NSUbiquityIdentityDidChangeNotification, object: nil)
            listenningForUbiquityChanges = true
        }

        let fileManager = NSFileManager.defaultManager()
        if let currentiCloudToken = fileManager.ubiquityIdentityToken {
            let newTokenData = NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken)
            k.Defaults.setObject(newTokenData, forKey: k.UD_IdentityToken)
        }
            else {
            k.Defaults.removeObjectForKey(k.UD_IdentityToken)
        }
    }
}

