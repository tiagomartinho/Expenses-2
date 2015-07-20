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
        return k.sharedSession.handleOpenURL(url) && k.isLinked
    }
}