import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let dbSession = DBSession(appKey: k.AppKey, appSecret: k.AppSecret, root: kDBRootAppFolder)
        DBSession.setSharedSession(dbSession)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if k.sharedSession.handleOpenURL(url) {
            if k.isLinked {
            }
            return true
        }
        return false
    }
}