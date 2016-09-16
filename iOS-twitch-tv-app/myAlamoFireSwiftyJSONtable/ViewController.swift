//
//  ViewController.swift
//  myAlamoFireSwiftyJSONtable
//
//  Created by Melissa Phillips on 9/13/16.
//  Copyright © 2016 Melissa Phillips Design. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class ViewController: UIViewController, MyTableViewCellDelegate {
		
	@IBOutlet weak var tableView: UITableView!
	
	struct UserData {
		
		var name: String
		var email: String
		var phone: String
		var website: String
	}
		
	var userDataArray = [UserData]()
	
	override func viewDidLoad() {

		super.viewDidLoad()
			
		loadJSONData()
	}

	override func didReceiveMemoryWarning() {
		
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func loadJSONData() {
		
		// Fake Online REST API for Testing and Prototyping
		//http://jsonplaceholder.typicode.com/users
			
		Alamofire.request(.GET, "http://jsonplaceholder.typicode.com/users", parameters: nil).responseString { response in

			
			if let jsonString = response.result.value {
			
				let json = JSON.parse(jsonString)
			
				for arrayEntry in json.arrayValue {
				
					let name = arrayEntry["name"].stringValue
					let phone = arrayEntry["phone"].stringValue
					let email = arrayEntry["email"].stringValue
					let website = arrayEntry["website"].stringValue

					self.userDataArray.append(UserData(name: name, email: email, phone: phone, website: website))
				}
			
			// Once we're done loading up the photoDataArray, force the table view to reload so
			// the cells get rebuilt using the data that we fetched from the test server.
						
				self.tableView.reloadData()
			
			} else {
			
					print("Failed to get a value from the response.")
			}
		}
	}
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
	
	// From UITableViewDataSource protocol.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return userDataArray.count
	}
	
	// From UITableViewDataSource protocol.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! MyTableViewCell
		
		cell.delegate = self
		
		let row = indexPath.row
		
		let fullUrl = userDataArray[row].website
		
		cell.websiteUrl = fullUrl
		
//		var shortUrl: String = ""
//		
//		// If the URL has "http://" or "https://" in it - remove it!
//		if fullUrl.lowercaseString.rangeOfString("http://") != nil {
//			shortUrl = fullUrl.stringByReplacingOccurrencesOfString("http://", withString: "")
//		} else if fullUrl.lowercaseString.rangeOfString("https://") != nil {
//			shortUrl = fullUrl.stringByReplacingOccurrencesOfString("https://", withString: "")
//		}
		
		cell.myWebsiteBtn.setTitle(userDataArray[row].website, forState: .Normal)
		cell.myPhoneBtn.setTitle(userDataArray[row].phone, forState: .Normal)
		cell.myEmailBtn.setTitle(userDataArray[row].email, forState: .Normal)
		cell.myNameBtn.setTitle(userDataArray[row].name, forState: .Normal)
		
		cell.emailAddress = userDataArray[row].email
		
//		cell.myNameBtn.setTitle(userDataArray[row].name, forState: [])
//		cell.myPhoneBtn.setTitle(userDataArray[row].phone, forState: [])
//		cell.myEmailBtn.setTitle(userDataArray[row].email, forState: [])
//		cell.myWebsiteBtn.setTitle(userDataArray[row].website, forState: [])
		
		return cell
	}
	
	// to give a warning if user is using a simulator
	
	func isSimulator() -> Bool {
		#if (arch(i386) || arch(x86_64)) && os(iOS)
			return true
		#else
			return false
		#endif
	}
	
	// Implemented from  MyTableViewCellDelegate
	// If this gets called we know that a user has tapped on the email button on one of our cells.
	func didTapEmail(email: String) {
		
		if isSimulator() {
			
			let alertController = UIAlertController(title: "Could Not Send Email",
			                                        message: "You can not send an email from the simulator!",
			                                        preferredStyle: .Alert)
			
			alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			self.presentViewController(alertController, animated: true, completion: nil)
			
			return
		}
		
		if MFMailComposeViewController.canSendMail() {
			
			let mailComposerVC = MFMailComposeViewController()
			mailComposerVC.mailComposeDelegate = self
			mailComposerVC.setToRecipients([email])
			mailComposerVC.setSubject("My Subject...")
			mailComposerVC.setMessageBody("Here's my email! Blah Blah Blah.", isHTML: false)
			
			self.presentViewController(mailComposerVC, animated: true, completion: nil)
			
		} else {
			
			let alertController = UIAlertController(title: "Could Not Send Email",
			                                        message: "Your device is not configured to send e-mail. Please check e-mail configuration and try again.",
			                                        preferredStyle: .Alert)
			
			alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			
			let configureAction = UIAlertAction(title: "Configure", style: .Default) { action in
				
				// Send the user to the device's Settings app.
				if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
					UIApplication.sharedApplication().openURL(appSettings)
				}
			}
			
			alertController.addAction(configureAction)
			
			self.presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	func didTapPhone(phone: String) {
		
		if isSimulator() {
			
			let alertController = UIAlertController(title: "Could Not Make Call",
			                                        message: "You can not make a call from the simulator!",
			                                        preferredStyle: .Alert)
			
			alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			self.presentViewController(alertController, animated: true, completion: nil)
			
			return
		}
		
		for i in userDataArray {
			
			if let url = NSURL(string: i.phone) {
				
				let alertController = UIAlertController(title: "Place Call",
				                                        message: "Do you wish to call \(i.phone)?",
				                                        preferredStyle: .Alert)
				
				alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
				
				let callAction = UIAlertAction(title: "Call", style: .Default) { action in
					
					UIApplication.sharedApplication().openURL(url)
				}
				
				alertController.addAction(callAction)
				
				self.presentViewController(alertController, animated: true, completion: nil)
				
			} else {
				
				print("Failed to convert phone number to NSURL")
			}
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate

extension ViewController: MFMailComposeViewControllerDelegate {
	
	// Implemented from MFMailComposeViewControllerDelegate...
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}




