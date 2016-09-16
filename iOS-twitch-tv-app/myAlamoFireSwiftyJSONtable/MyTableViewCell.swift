//
//  MyTableViewCell.swift
//  myAlamoFireSwiftyJSONtable
//
//  Created by Melissa Phillips on 9/14/16.
//  Copyright © 2016 Melissa Phillips Design. All rights reserved.
//


import UIKit

protocol MyTableViewCellDelegate {
	
	func didTapEmail(email: String)
	
	func didTapPhone(phone: String)
}

class MyTableViewCell: UITableViewCell {
	
	@IBOutlet weak var myNameBtn: UIButton!
	@IBOutlet weak var myPhoneBtn: UIButton!
	@IBOutlet weak var myEmailBtn: UIButton!
	@IBOutlet weak var myWebsiteBtn: UIButton!
	
	var websiteUrl: String?
	var emailAddress: String?
	var phoneNumber: String?
	
	var delegate: MyTableViewCellDelegate?

	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	@IBAction func loadWebsite(sender: UIButton) {
		
		// Since MyTableViewCell can safely call openURL() - we'll just do it here.
		if let url = NSURL(string: websiteUrl!) {
			UIApplication.sharedApplication().openURL(url)
		}
	}
	
	@IBAction func createEmail(sender: UIButton) {
		
		// Since MyTableViewCell CAN NOT call presentViewController() which is
		// required to launch MFMailComposeViewController, we will need to
		// notify someone else about this event and hope that they will handle
		// it for us.
		
		// If someone has implemented our MyTableViewCellDelegate - call them
		// and let them know that the email button was tapped.
		
		delegate?.didTapEmail(emailAddress!)
	}
	
	@IBAction func makeCall(sender: UIButton) {
		
		// Since MyTableViewCell CAN NOT call presentViewController() which is
		// required to launch MFMailComposeViewController, we will need to
		// notify someone else about this event and hope that they will handle
		// it for us.
		
		// If someone has implemented our MyTableViewCellDelegate - call them
		// and let them know that the email button was tapped.
		
		delegate?.didTapPhone(phoneNumber!)
	}
}

