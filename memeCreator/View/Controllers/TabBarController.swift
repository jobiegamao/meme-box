//
//  File.swift
//  memeCreator
//
//  Created by may on 4/9/23.
//

import UIKit

class TabBarController: UITabBarController{
	
	@IBInspectable var initialIndex: Int = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		selectedIndex = initialIndex
	}
}

