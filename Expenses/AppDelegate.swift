import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateiCloudToken:", name: NSUbiquityIdentityDidChangeNotification, object: nil)
        updateiCloudToken()
        return true
    }
    
    func updateiCloudToken(notification: NSNotification){
        updateiCloudToken()
    }
    
    func updateiCloudToken(){
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

