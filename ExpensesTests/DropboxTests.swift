import UIKit
import XCTest
import SwiftyDropbox

class DropboxTests: XCTestCase {
    
    let client = Dropbox.authorizedClient
    
    func testCurrentAccount(){
        let expectation = expectationWithDescription(nil)

        client!.usersGetCurrentAccount().response { response, error in
            if let account = response {
                XCTAssertEqual("t.martinho@live.com.pt", account.email)
                expectation.fulfill()
            } else {
                println(error!)
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
        }
    }
    
    func testListFolderContents(){
        let expectation = expectationWithDescription(nil)

        client!.filesListFolder(path: "").response { response, error in
            if let result = response {
                for entry in result.entries {
                    println(entry.name)
                }
                expectation.fulfill()
            } else {
                println(error!)
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
        }
    }
    
    func testUploadFile(){
        let expectation = expectationWithDescription(nil)

        let fileName = "hello.txt"
        let fileData = "Hello!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        client!.filesUpload(path: "/" + fileName, body: fileData!).response { response, error in
            if let metadata = response {
                expectation.fulfill()
            } else {
                println(error!)
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
        }
    }
    
    func testDownloadFile(){
        let expectation = expectationWithDescription(nil)
        
        client!.filesDownload(path: "/hello.txt").response { response, error in
            if let (metadata, data) = response {
                expectation.fulfill()
            } else {
                println(error!)
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
        }
    }

    func testGetFileMetadata(){
        let expectation = expectationWithDescription(nil)

        client!.filesGetMetadata(path: "/hello.txt").response { response, error in
            if let metadata = response {
                println("Name: \(metadata.name)")
                if let file = metadata as? Files.FileMetadata {
                    println("This is a file.")
                    println("File size: \(file.size)")
                    expectation.fulfill()
                } else if let folder = metadata as? Files.FolderMetadata {
                    println("This is a folder.")
                }
            } else {
                println(error!)
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
        }
    }
}