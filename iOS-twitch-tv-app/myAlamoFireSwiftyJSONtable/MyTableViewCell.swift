//
//  MyTableViewCell.swift
//  myAlamoFireSwiftyJSONtable
//
//  Created by Melissa Phillips on 9/14/16.
//  Copyright © 2016 Melissa Phillips Design. All rights reserved.
//


import UIKit

class MyTableViewCell: UITableViewCell {
	
	@IBOutlet weak var myNameBtn: UIButton!
	@IBOutlet weak var myPhoneBtn: UIButton!
	@IBOutlet weak var myEmailBtn: UIButton!
	@IBOutlet weak var myWebsiteBtn: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}

