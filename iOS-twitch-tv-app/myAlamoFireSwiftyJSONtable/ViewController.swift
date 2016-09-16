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

class ViewController: UIViewController, UITableViewDataSource {
		
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
	
	// From UITableViewDataSource protocol.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return userDataArray.count
	}
	
	// From UITableViewDataSource protocol.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! MyTableViewCell
		
		let row = indexPath.row
		
		cell.myNameText.text = userDataArray[row].name
		cell.myEmailText.text = userDataArray[row].email
		cell.myPhoneText.text = userDataArray[row].phone
		cell.myWebsiteText.text = userDataArray[row].website

		return cell
	}
}

