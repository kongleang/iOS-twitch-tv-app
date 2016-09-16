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

class ViewController: UIViewController {
		
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
	
	// MARK: - Actions
	
	@IBAction func callPhoneNumber(sender: UIButton) {
		
		if let url = NSURL(string: self.userDataArray[2].phone) {
			
			let alertController = UIAlertController(title: "Place Call",
			                                        message: "Do you wish to call \(self.userDataArray[2].phone)?",
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
	
	@IBAction func gotoWebsite(sender: UIButton) {
		
		if let url = NSURL(string: "https://guildsa.org") {
			
			UIApplication.sharedApplication().openURL(url)
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
		
		let row = indexPath.row
		
		cell.myNameBtn.setTitle(userDataArray[row].name, forState: [])
		cell.myPhoneBtn.setTitle(userDataArray[row].phone, forState: [])
		cell.myEmailBtn.setTitle(userDataArray[row].email, forState: [])
		cell.myWebsiteBtn.setTitle(userDataArray[row].website, forState: [])
		
		return cell
	}

}

// MARK: - MFMailComposeViewControllerDelegate

extension ViewController: MFMailComposeViewControllerDelegate {
	
	@IBAction func createEmail(sender: UIButton) {
		
		if MFMailComposeViewController.canSendMail() {
			
			let mailComposerVC = MFMailComposeViewController()
			mailComposerVC.mailComposeDelegate = self
			mailComposerVC.setToRecipients(["mnetherwood@gmail.com"])
			mailComposerVC.setSubject("My Subject...")
			mailComposerVC.setMessageBody("Hello, I wanted to reach out to you about...", isHTML: false)
			
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
	
	// Implemented from MFMailComposeViewControllerDelegate...
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}

