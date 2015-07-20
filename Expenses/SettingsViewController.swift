import UIKit
import RealmSwift
import MessageUI

class SettingsViewController: UITableViewController, DBRestClientDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!

    @IBOutlet weak var uploadDropbox: UIButton!
    @IBOutlet weak var downloadDropbox: UIButton!
    @IBOutlet weak var linkDropbox: UIButton!
    
    let textFieldShouldReturn = TextFieldShouldReturn()
    
    // MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersonsNames()
    }
    
    func loadPersonsNames(){
        textFieldShouldReturn.addTextField(person1)
        textFieldShouldReturn.addTextField(person2)
        person1.text = k.Person1Name
        person2.text = k.Person2Name
    }
    
    // MARK : viewWillAppear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    func updateUI(){
        if k.isLinked {
            linkDropbox.setTitle("Unlink Dropbox", forState: UIControlState.Normal)
            uploadDropbox.enabled = true
            downloadDropbox.enabled = true
        }
        else {
            linkDropbox.setTitle("Link Dropbox", forState: UIControlState.Normal)
            uploadDropbox.enabled = false
            downloadDropbox.enabled = false
        }
    }
    
    @IBAction func person(sender: UITextField) {
        let name = sender.text.removeWhitespaces()
        
        if sender.placeholder?.hasSuffix("1") ?? false {
            if name == "" {
                k.Defaults.removeObjectForKey(k.UD_Person1)
            }
            else {
                k.Defaults.setObject(name, forKey: k.UD_Person1)
            }
        }
        
        if sender.placeholder?.hasSuffix("2") ?? false {
            if name == "" {
                k.Defaults.removeObjectForKey(k.UD_Person2)
            }
            else {
                k.Defaults.setObject(name, forKey: k.UD_Person2)
            }
        }
        
        k.Defaults.synchronize()
    }
    
    @IBAction func promptToDeleteAllExpenses() {
        var alert = UIAlertController(title: "Attention", message: "This will delete all your expenses", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            RealmUtilities.deleteAllEntries()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadToDropbox() {
        if k.isLinked {
            let restClient = DBRestClient(session: k.sharedSession)
            restClient.delegate = self
            let realmPath = Realm().path
            let realmFilename = "default.realm"
            restClient.uploadFile(realmFilename, toPath: "/", withParentRev: nil, fromPath: realmPath)
        }
    }
    
    @IBAction func downloadFromDropbox() {
    }
    
    func restClient(client: DBRestClient!, uploadProgress progress: CGFloat, forFile destPath: String!, from srcPath: String!) {
        println("\(progress)")
    }
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        println("File uploaded successfully")
    }
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        println("File failed with error")
    }
    
    @IBAction func linkWithDropbox() {
        if k.isLinked == false {
            k.sharedSession.linkFromController(self)
        }
        else {
            k.sharedSession.unlinkAll()
            updateUI()
        }
    }
    
    // MARK : Send Email

    @IBAction func sendByEmail() {
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("Expenses")
            mailComposer.setMessageBody("Expenses Backup", isHTML: false)
            
            let filePath = Realm().path
            if let fileData = NSData(contentsOfFile: filePath) {
                mailComposer.addAttachmentData(fileData, mimeType: ".realm", fileName: "Expenses.realm")
            }
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func overwrite(){
        // copy over old data files for migration
        let defaultPath = Realm().path
        let defaultParentPath = defaultPath.stringByDeletingLastPathComponent
        
        let v0Path = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("preloaded.realm")
        NSFileManager.defaultManager().removeItemAtPath(defaultPath, error: nil)
        NSFileManager.defaultManager().copyItemAtPath(v0Path, toPath: defaultPath, error: nil)
    }
}
