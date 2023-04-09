//
//  Meme.swift
//  memeCreator
//
//  Created by may on 4/9/23.
//

import UIKit

class Meme: NSObject, Codable{
	var title: String
	var image: String
	
	init(title: String, image: String) {
		self.title = title
		self.image = image
	}
}
